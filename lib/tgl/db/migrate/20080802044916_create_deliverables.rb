#
# $Id: 20080802044916_create_deliverables.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateDeliverables < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :deliverables do |t|
	      t.string :name
        t.string :number
	      t.integer :work_package_id
	      t.string :nature
	      t.string :dissemination_level
	      t.integer :due
	      t.integer :milestone_id
        t.integer :project_id
	
	      t.timestamps
	    end
      add_index :deliverables, :work_package_id
      add_index :deliverables, :milestone_id
      add_index :deliverables, :project_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_index :deliverables, :work_package_id
      remove_index :deliverables, :milestone_id
      remove_index :deliverables, :project_id
      drop_table :deliverables
    end
  end
end
