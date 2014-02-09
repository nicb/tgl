#
# $Id: 20080801221719_create_projects.rb 2 2011-01-16 01:15:24Z nicb $
#
class CreateProjects < ActiveRecord::Migration
  def self.up
    ActiveRecord::Base.transaction do
	    create_table :projects do |t|
	      t.string :title
	      t.string :acronym
	      t.string :ict_call_no
	      t.string :year
	      t.string :call
	      t.string :project_type
	      t.string :type_acro
	      t.integer :challenge
	      t.string :topic
	      t.integer :duration
        t.integer :proposal_number
	
	      t.timestamps
	    end
    end
  end

  def self.down
    ActiveRecord::Base.transaction do
      drop_table :projects
    end
  end
end
