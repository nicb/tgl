#
# $Id: partner_test.rb 2 2011-01-16 01:15:24Z nicb $
#

require 'test/test_helper'

class PartnerTest < Test::Unit::TestCase

  def setup
    assert @partners = Partner.all
    #
    # this is specific of our current data set, may change in the future
    #
    assert @partner_classes =
    {
      'UNIPD' => { :cm => 'STFR', :oh => 0.6, :rtdf => 0.75 },
      'FIS' => { :cm => 'STFR', :oh => 0.6, :rtdf => 0.75 },
      'IRCAM' => { :cm => 'AIC', :oh => 0.85, :rtdf => 0.5 },
      'UPF' => { :cm => 'STFR', :oh => 0.6, :rtdf => 0.75 },
      'EURIX' => { :cm => 'STFR', :oh => 0.6, :rtdf => 0.75 },
      'IBM' => { :cm => 'AIC', :oh => 0.92, :rtdf => 0.5 },
      'RAI' => { :cm => 'STFR', :oh => 0.6, :rtdf => 0.75 },
      'TELCO' => { :cm => 'FR', :oh => 0.2, :rtdf => 0.5 },
    }
  end

  def test_meta_method_existence
    @partners.each do
      |p|
	    WorkPackage::ACTIVITY_TYPES.each do
	      |at|
	      Partner.cost_types.each do
	        |ct|
	        assert meth = Partner.method_name(ct, at)
	        assert p.respond_to?(meth), "#{meth.to_s} method does not exist"
          assert p.send(meth)
	        assert ctmeth = Partner.total_by_cost_type_method_name(ct)
	        assert p.respond_to?(ctmeth), "#{ctmeth.to_s} method does not exist"
          assert p.send(ctmeth)
	        assert atmeth = Partner.total_by_activity_method_name(at)
	        assert p.respond_to?(atmeth), "#{atmeth.to_s} method does not exist"
          assert p.send(atmeth)
	        assert funmeth = Partner.funded_by_activity_method_name(at)
	        assert p.respond_to?(funmeth), "#{funmeth.to_s} method does not exist"
          assert p.send(funmeth)
	      end
	    end
    end
  end

  def test_cost_model_description
    assert p = Partner.first
    assert p.valid?
    @partner_classes.values.each do
      |v|
      assert cm = create_cost_model(p, v)
      assert cm.valid?
      assert p.reload
      assert cmd_should_be = cost_model_description(v[:cm])
      assert_equal cmd_should_be, p.cost_model.description
      assert_equal v[:oh], p.cost_model.overhead_rate
      assert_equal v[:rtdf], p.cost_model.funded_rtd
    end
  end

private

  def cost_model_description(code)
    result = case code
             when /^AIC$/ then 'Actual Indirect Costs'
             when /^FR$/ then 'Flat Rate (p.t. 20\%)'
             when /^STFR$/ then 'Transitional Flat Rate (p.t. 60\%)'
             else raise("unknown cost model #{code}")
             end
    result
  end

  def create_cost_model(p, args)
    p.cost_model.destroy if p.cost_model
    result = case args[:cm]
             when /^AIC$/ then AICCostModel.create(:partner => p, :overhead_rate => args[:oh])
             when /^FR$/ then FRCostModel.create(:partner => p)
             when /^STFR$/ then STFRCostModel.create(:partner => p)
             else raise("unknown cost model #{code}")
             end
    result
  end
end
