#
# $Id: project.rb 2 2011-01-16 01:15:24Z nicb $
#
class Project < ActiveRecord::Base

  has_many :partners
  has_many :work_packages
  has_many :milestones
  has_many :deliverables

  def initialize(parms = {})
    super(parms)
  end

  EMPTY_PROPOSAL_NUMBER_STRING = '000000' unless defined?(EMPTY_PROPOSAL_NUMBER_STRING)

  def proposal_color
    result = proposal_number == EMPTY_PROPOSAL_NUMBER_STRING ? 'lgray' : 'black'
    return result
  end

  def proposal_number
    result = read_attribute('proposal_number')
    result = result.blank? ? EMPTY_PROPOSAL_NUMBER_STRING : result
    return result
  end

  def total_budget
    common_total { |p| p.total_total_costs.to_f }
  end

  def total_funded
    common_total { |p| p.total_funded_costs.to_f }
  end

  WorkPackage::ACTIVITY_TYPES.each do
    |at|
    atd = at.downcase
    meth = "#{atd}_color"
    pta_meth = "#{atd}_activity_color"
    define_method(meth) { self.pta.send("#{pta_meth}") }
  end

protected

  def pta
    ProjectTypeHelper::Factory.generate(self.type_acro)
  end

private

  def common_total
    ps = Partner.find(:all, :order => 'position')
    result = 0.0
    ps.each { |p| result += yield(p) }
    return result
  end

end
