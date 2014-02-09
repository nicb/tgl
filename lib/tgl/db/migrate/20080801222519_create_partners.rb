#
# $Id: 20080801222519_create_partners.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreatePartners < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :partners do |t|
        t.integer :position
        t.string :type
	      t.string :name
	      t.string :acronym
	      t.string :country
        t.integer :pic
	      t.float :pm_cost
	      t.string :cost_model
	      t.string :lump_sum
	      t.float :audit
	      t.float :personnel_other_costs_ratio
        t.float :maximum_effort
        t.float :allocated_budget
        t.text :notes
        t.integer :project_id
 #      t.float :funded_rtd
	
	      t.timestamps
	    end
        add_index :partners, :project_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      drop_table :partners
    end
  end
end
