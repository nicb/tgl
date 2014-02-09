#
# $Id: partner_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/../../lib/ec_reader/column_reader'

class PartnerReader < ColumnReader
  attr_reader :partners

  class TooManyRequirementsException < StandardError
  end

  class <<self

  private

	  PARTNER_COLUMN_MAP =
	  {
	    'Partner Name' => :name,
	    'Partner acro' => :acronym,
	    'Country' => :country,
	    'PIC' => :pic,
	    'P/M Cost' => :pm_cost,
	    'Cost model' => :cost_model,
	    'Lump sum' => :lump_sum,
	    'OH rate' => :overhead_rate,
	    'Audit costs' => :audit,
	    'Pers./Other costs (%)' => :personnel_other_costs_ratio,
	    'Effort' => :maximum_effort,
	    'Allocated Budget' => :allocated_budget,
      'Notes' => :notes,
	  }

  protected

	  def column_hash
	    return PARTNER_COLUMN_MAP
	  end

  end

public

  def initialize(df)
    super(df)
    @partners = []
  end

  def load
    all_attribs = data_to_array_of_hashes
    n = 1
#   p = Project.find_by_acronym(Environment::PROJECT)
    p = Project.first
    all_attribs.each do
      |a|
      a[:position] = n
      a[:project] = p
      cm = a.delete(:cost_model)
      oh_rate = a.delete(:overhead_rate)
      partner = Partner.create(a)
      raise("Could not create partner #{a[:acronym]}") unless partner
      raise("Partner #{a[:acronym]} is invalid (#{partner.errors.full_messages.join(', ')})") unless partner.valid?
      cmclass = (cm + 'CostModel').constantize
      cost_model = cmclass.create(:partner => partner, :overhead_rate => oh_rate)
      raise("Could not create cost model #{cm}") unless cost_model
      raise("Cost model #{cmclass.name} is invalid (#{cost_model.errors.full_messages.join(', ')})") unless cost_model.valid?
      partner.update_attributes!(:cost_model => cost_model)
      @partners << partner
      n += 1
    end
    return @partners
  end

end
