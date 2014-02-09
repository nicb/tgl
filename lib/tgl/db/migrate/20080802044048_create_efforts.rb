#
# $Id: 20080802044048_create_efforts.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateEfforts < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :efforts do |t|
	      t.float :person_months
	      t.integer :work_package_id
	      t.integer :partner_id
	
	      t.timestamps
	    end
      add_index :efforts, :work_package_id
      add_index :efforts, :partner_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      remove_index :efforts, :work_package_id
      remove_index :efforts, :partner_id
      drop_table :efforts
    end
  end
end
