#
# $Id: 20081214224423_create_partner_skills.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreatePartnerSkills < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :partner_skills, :id => false do |t|
	      t.integer :skill_id
        t.integer :partner_id
	
	      t.timestamps
	    end
      add_index :partner_skills, :skill_id
      add_index :partner_skills, :partner_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_index :partner_skills, :skill_id
      remove_index :partner_skills, :partner_id
      drop_table :skills
    end
  end
end
