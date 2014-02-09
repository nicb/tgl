#
# $Id: milestone.rb 2 2011-01-16 01:15:24Z nicb $
#
class Milestone < ActiveRecord::Base
  belongs_to :project
  has_many :deliverables

  def work_packages
    return deliverables.map { |d| "WP" + d.work_package.position.to_s }
  end
end
