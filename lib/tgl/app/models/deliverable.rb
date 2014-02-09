#
# $Id: deliverable.rb 2 2011-01-16 01:15:24Z nicb $
#
class Deliverable < ActiveRecord::Base
  belongs_to :work_package
  belongs_to :milestone
  belongs_to :project

  def d_id
    return "D" + work_package.position.to_s + "." + number.to_s
  end

end
