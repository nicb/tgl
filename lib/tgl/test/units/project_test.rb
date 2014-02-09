#
# $Id: project_test.rb 2 2011-01-16 01:15:24Z nicb $
#

require 'test/test_helper'

class ProjectTest < Test::Unit::TestCase

  def setup
    assert @p = Project.first
    assert @p.valid?
    #
    # these are the colors for a STREP project type
    #
    assert @black_acts = [ 'RTD', 'DEMO', 'MGMT' ]
    assert @lgray_acts = [ 'SUPP', 'COORD', 'OTHER' ]
  end

  def test_project_type
    assert_equal 'STREP', @p.type_acro
  end

  def test_meta_methods
    WorkPackage::ACTIVITY_TYPES.each do
      |at|
      assert meth = "#{at.downcase}_color"
      assert @p.respond_to?(meth)
    end
  end

  def test_colors
    @black_acts.each do
      |at|
      assert meth = "#{at.downcase}_color"
      assert_equal 'black', @p.send(meth)
    end
    @lgray_acts.each do
      |at|
      assert meth = "#{at.downcase}_color"
      assert_equal 'lgray', @p.send(meth)
    end
  end

end
