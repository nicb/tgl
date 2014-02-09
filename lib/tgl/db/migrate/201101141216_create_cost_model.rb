#
# $Id: 201101141216_create_cost_model.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateCostModel < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :cost_models do |t|
	      t.string :type, :null => false
        t.string :acronym, :null => false
        t.string :description, :null => false
        t.float :funded_rtd, :null => false
        t.float :overhead_rate, :null => false
        t.integer :partner_id, :null => false, :unique => true
	
	      t.timestamps
	    end
      add_index :cost_models, :partner_id
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      drop_table :cost_models
    end
  end
end
