#
# $Id: 20081214224223_create_skills.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateSkills < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :skills do |t|
	      t.string :name
	
	      t.timestamps
	    end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      drop_table :skills
    end
  end
end
