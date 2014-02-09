#
# $Id: effort.rb 2 2011-01-16 01:15:24Z nicb $
#
class Effort < ActiveRecord::Base
  belongs_to :partner
  belongs_to :work_package
end
