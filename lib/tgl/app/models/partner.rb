#
# $Id: partner.rb 2 2011-01-16 01:15:24Z nicb $
#
class Partner < ActiveRecord::Base

  belongs_to :project
  has_many :leaderships, :class_name => 'WorkPackage'
  has_many :efforts
  has_many :work_packages, :through => :efforts
  has_many :partner_skills
  has_many :skills, :through => :partner_skills
  has_one :cost_model

  class <<self
    
    def global_csv_dump
      result = []
      head = ['', 'Partner', 'Alloc. Budget', 'O/H ratio', 'P/O ratio', 'P/M', 'Effort', 'Personnel', 'Other', 'Direct', 'Indirect', 'Budget', ]
      result << head
      ps = Partner.find(:all, :order => 'position')
      ps.each do
        |p|
        ps_line = []
        ps_line << p.partner_tag << p.acronym
        ps_line << p.allocated_budget
        ps_line << p.cost_model.overhead_rate << p.personnel_other_costs_ratio
        ps_line << p.pm_cost << p.maximum_effort
        ps_line << p.personnel_costs << p.other_costs << p.direct_costs << p.indirect_costs
        ps_line << p.actual_budget
        result << ps_line
      end
      return result
    end

  end

  def cap_text_number
    return NumberUtils::to_cap_string(position)
  end

  def partner_tag
    tag = position == 1 ? 'CO--' : 'CP--'
    return tag + position.to_s
  end

  def is_leader?(wp)
    return read_attribute('id') == wp.leader.read_attribute('id')
  end

  def bold_if_leader(wp)
    return is_leader?(wp) ? '\bfseries' : ''
  end

  def has_skill?(s)
    result = skills.index(s) ? true : false
    return result
  end

  def total_effort
    result = 0
    efforts.each { |e| result += e.person_months }
    return result
  end

  def budgeted_direct_costs
    return allocated_budget.to_f/(1+cost_model.overhead_rate.to_f)
  end

  def budgeted_indirect_costs
    return budgeted_direct_costs.to_f * cost_model.overhead_rate.to_f
  end

  def budgeted_personnel_costs
    return budgeted_direct_costs.to_f/(1+personnel_other_costs_ratio.to_f)
  end

  def budgeted_other_costs
    return budgeted_personnel_costs.to_f * personnel_other_costs_ratio.to_f
  end

  def personnel_costs
    me = maximum_effort.to_f
    pm = pm_cost.to_f
    return me * pm
  end

  def other_costs
    return personnel_costs.to_f * personnel_other_costs_ratio.to_f
  end

  def direct_costs
    return personnel_costs + other_costs
  end

  def indirect_costs
    return direct_costs * cost_model.overhead_rate.to_f
  end

  def actual_budget
    return direct_costs + indirect_costs
  end

  def funding_requested
  end

  def expected_other_effort
    return audit.to_f/pm_cost.to_f
  end

  def calculate_pm_cost(me)
    result = budgeted_personnel_costs.to_f / me.to_f
    update_attributes!(:pm_cost => result)
    return result
  end

private

  def fillable_attribute(key, &block)
    result = read_attribute(key)
    unless result
      result = yield
      update_attributes!(key => result)
    end
    return result
  end

public

  def pm_cost
    return fillable_attribute('pm_cost') { return budgeted_personnel_costs.to_f / maximum_effort.to_f } 
  end

  def maximum_effort
    return fillable_attribute('maximum_effort') { return (budgeted_personnel_costs.to_f / pm_cost.to_f).ceil.to_i } 
  end

  def effort_color
    result = case total_effort <=> maximum_effort
      when -1 : 'green'
      when  0 : 'black'
      when  1 : 'red'
    end
    return result
  end

  def other_effort_color
  end

  #
  # A3.1 Forms methods
  #
public

  def personnel_costs_by_activity(type_of_act)
    result = 0.0
    efforts.each do
      |e|
      result += e.person_months.to_f if e.work_package.activity == type_of_act
    end
    return (result * pm_cost.to_f).int_round
  end

  def other_costs_costs_by_activity(type_of_act)
    (personnel_costs_by_activity(type_of_act) * personnel_other_costs_ratio.to_f).int_round
  end 

  def indirect_costs_by_activity(type_of_act)
    ((personnel_costs_by_activity(type_of_act)+other_costs_costs_by_activity(type_of_act)) * cost_model.overhead_rate.to_f).int_round
  end

  def funded_costs_by_activity(toa)
    meth = "funded_#{toa.to_s.downcase}"
    ((personnel_costs_by_activity(toa)+other_costs_costs_by_activity(toa)+indirect_costs_by_activity(toa)) * cost_model.send(meth).to_f).int_round
  end

public

  class << self

	  def method_name(cost_type, activity_type)
	    "#{cost_type.to_s}_#{activity_type.downcase}"
	  end
	
	  def common_method_name(ct)
	    "#{ct.to_s}_costs_by_activity"
	  end
	
    def total_by_activity_method_name(act)
	    "total_#{act.to_s.downcase}"
	  end

    def total_by_activity_direct_method_name(act)
	    "total_#{act.to_s.downcase}_direct_costs"
    end

    def total_by_activity_indirect_method_name(act)
	    "total_#{act.to_s.downcase}_indirect_costs"
    end

    def funded_by_activity_method_name(act)
	    "funded_#{act.to_s.downcase}"
    end

    def total_by_cost_type_method_name(ct)
	    "total_#{ct.to_s}_costs"
    end

	  def cost_types
	    [:personnel, :other_costs, :indirect]
	  end

  end

  #
  # create all helper calls such as:
  # personnel_rtd_costs
  # personnel_demo_costs
  # etc.
  # 
  # and also
  #
  # define total by activity helpers, such as:
  # total_rtd_costs
  # total_mgmt_costs
  # etc.
  #
  WorkPackage::ACTIVITY_TYPES.each do
    |at|
    cost_types.each do
      |cost_type|
      meth_name = method_name(cost_type, at)
      mcall = common_method_name(cost_type)
      define_method(meth_name) { send("#{mcall}", "#{at}") }
    end
    ct_meth = total_by_activity_method_name(at)
    define_method(ct_meth) do
      total = 0.0
      self.class.cost_types.each do
        |cost_type|
        mn = self.class.method_name(cost_type, "#{at}")
        total += send(mn)
      end
      total
    end
    ctd_meth = total_by_activity_direct_method_name(at)
    define_method(ctd_meth) { direct_costs_by_activity("#{at}") }
    cti_meth = total_by_activity_indirect_method_name(at)
    define_method(cti_meth) { indirect_costs_by_activity("#{at}") }
    fun_meth = funded_by_activity_method_name(at)
    define_method(fun_meth) { funded_costs_by_activity("#{at}") }
  end

  #
  # define total by cost_type helpers, such as:
  # total_personnel
  # total_other_costs
  # etc.
  #
  cost_types.each do
    |ct|
    tmn = total_by_cost_type_method_name(ct) 
    define_method(tmn) do
      total = 0.0
      WorkPackage::ACTIVITY_TYPES.each do
        |at|
        meth_name = self.class.method_name("#{ct.to_s}", at)
        total += send(meth_name)
      end
      total
    end
  end

  def total_direct_costs
    total_personnel_costs + total_other_costs_costs
  end

  def total_total_costs
    result = 0.0
    self.class.cost_types.each do
      |ct|
      meth = self.class.total_by_cost_type_method_name(ct)
      result += send(meth)
    end
    verify = 0.0
    WorkPackage::ACTIVITY_TYPES.each do
      |at|
      meth = self.class.total_by_activity_method_name(at)
      verify += send(meth)
    end 
    eps = result-verify
    $stderr.puts("Totals do not match! (#{result} != #{verify})") if eps.abs > 1.0
    verify = actual_budget
    eps = result-verify
    $stderr.puts("Total does not match to actual budget! (#{result} != #{verify})") if eps.abs > 1.0
    return result
  end

  def total_funded_costs
    result = 0.0
    WorkPackage::ACTIVITY_TYPES.each do
      |at|
      meth = self.class.funded_by_activity_method_name(at)
      result += send(meth)
    end
    result
  end

end
