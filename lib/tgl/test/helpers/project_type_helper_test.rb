#
# $Id: project_type_helper_test.rb 2 2011-01-16 01:15:24Z nicb $
#

require 'test/test_helper'

class ProjectTypeHelperTest < Test::Unit::TestCase

  def setup
    assert @ptypes =
    {
      'STREP' => { 'black' => [ 'RTD', 'DEMO', 'MGMT' ], 'lgray' => [ 'SUPP', 'COORD', 'OTHER' ] },
      'CA'    => { 'black' => [ 'COORD', 'MGMT', 'OTHER' ], 'lgray' => [ 'SUPP', 'RTD', 'DEMO' ] },
      'CSA'   => { 'black' => [ 'SUPP', 'MGMT', 'OTHER' ], 'lgray' => [ 'COORD', 'RTD', 'DEMO' ] },
    }
    assert @ats = WorkPackage.activity_types
  end

  def test_meta_methods
    @ptypes.keys.each do
      |pt|
      assert ptype_class = ProjectTypeHelper::Factory.generate(pt)
      assert should_be = ('ProjectTypeHelper::' + pt + 'ProjectType').constantize
      assert_equal should_be, ptype_class
      @ats.each do
        |at|
        assert meth = "#{at.downcase}_activity_color".intern
        assert ptype_class.respond_to?(meth), "class #{ptype_class.name} does not respond to method #{meth.to_s}"
      end
    end
  end

  def test_colors
    @ptypes.each do
      |pt, attrs|
      assert ptype_class = ProjectTypeHelper::Factory.generate(pt)
      assert should_be = ('ProjectTypeHelper::' + pt + 'ProjectType').constantize
      assert_equal should_be, ptype_class
      @ats.each do
        |at|
        assert meth = "#{at.downcase}_activity_color".intern
        assert color_should_be = guess_color(pt, at)
        assert_equal color_should_be, ptype_class.send(meth), "#{ptype_class.name}, #{at}"
      end
    end
  end

private

  def guess_color(ptype, atype)
    @ptypes[ptype]['black'].index(atype) ? 'black' : 'lgray'
  end

end
