#
# $Id: 20080802045235_create_milestones.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateMilestones < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :milestones do |t|
	      t.string :name
        t.integer :position
	      t.integer :month
        t.integer :project_id
	
	      t.timestamps
	    end
      add_index :milestones, :project_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_index :milestones, :project_id
      drop_table :milestones
    end
  end
end
