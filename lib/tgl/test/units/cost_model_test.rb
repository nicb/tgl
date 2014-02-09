#
# $Id: cost_model_test.rb 2 2011-01-16 01:15:24Z nicb $
#

require 'test/test_helper'

class CostModelTest < Test::Unit::TestCase

  def setup
    assert @p = Partner.first
    assert @cost_models = 
    {
      'AIC' => { :overhead_rate => 0.85, :partner => @p },
      'FR' => { :partner => @p },
      'STFR' => { :partner => @p },
    }
  end

  def test_cost_model_creation
    @cost_models.each do
      |k, v|
      assert @p.cost_model.destroy if @p.cost_model
      assert @p.reload
      assert cm_class = (k + 'CostModel').constantize
      assert cm = cm_class.create(v)
      assert cm.valid?, "Cost model #{cm.class.name} invalid: #{cm.errors.full_messages.join(', ')}"
    end
  end

end
