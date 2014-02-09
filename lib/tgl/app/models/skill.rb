#
# $Id: skill.rb 2 2011-01-16 01:15:24Z nicb $
#
class Skill < ActiveRecord::Base
  has_many :partner_skills
  has_many :partners, :through => :partner_skills

end
