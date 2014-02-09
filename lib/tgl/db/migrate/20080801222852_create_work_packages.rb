#
# $Id: 20080801222852_create_work_packages.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateWorkPackages < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :work_packages do |t|
        t.integer :position
	      t.string :name
	      t.string :activity
	      t.integer :leader_id
	      t.integer :start_month
	      t.integer :end_month
	      t.integer :milestone_id
        t.integer :project_id
        t.string  :type
	
	      t.timestamps
	    end
      add_index :work_packages, :leader_id
      add_index :work_packages, :milestone_id
      add_index :work_packages, :project_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      drop_table :work_packages
    end
  end
end
