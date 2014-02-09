#
# $Id: partner_skill.rb 2 2011-01-16 01:15:24Z nicb $
#
class PartnerSkill < ActiveRecord::Base
  belongs_to :partner
  belongs_to :skill
end
