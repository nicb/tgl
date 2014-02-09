#
# $Id: cost_model.rb 2 2011-01-16 01:15:24Z nicb $
#
class CostModel < ActiveRecord::Base

  belongs_to :partner

  validates_presence_of :type, :acronym, :description, :funded_rtd, :overhead_rate, :partner_id
  validates_uniqueness_of :partner_id

  def funded_demo
    0.5
  end

  def funded_supp
    0.5
  end

  def funded_coord
    self.funded_rtd
  end

  def funded_mgmt
    1.0
  end

  def funded_other
    1.0
  end

end

class AICCostModel < CostModel

  def initialize(parms = {})
    parms.update(:acronym => 'AIC', :description => 'Actual Indirect Costs', :funded_rtd => 0.5)
    super(parms)
  end

end

class FRCostModel < CostModel

  def initialize(parms = {})
    parms.update(:acronym => 'FR', :description => 'Flat Rate (p.t. 20\%)', :funded_rtd => 0.5, :overhead_rate => 0.2)
    super(parms)
  end

end

class STFRCostModel < CostModel

  def initialize(parms = {})
    parms.update(:acronym => 'STFR', :description => 'Transitional Flat Rate (p.t. 60\%)', :funded_rtd => 0.75, :overhead_rate => 0.6)
    super(parms)
  end

end
