#
# $Id: deliverable_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/../../lib/ec_reader/column_reader'

class DeliverableReader < ColumnReader
  attr_reader :deliverables

private

  DELIVERABLE_COLUMN_MAP =
  {
    'WP No.' => :work_package,
    'N.' => :number,
    'Deliverable Name' => :name,
    'Nature' => :nature,
    'Diss. Level' => :dissemination_level,
    'Date (month)' => :due,
    'Milestone' => :milestone,
  }

protected

  def self.column_hash
    return DELIVERABLE_COLUMN_MAP
  end

public

  def initialize(df)
    super(df)
    @deliverables = []
  end

  def load
#   p = Project.find_by_acronym(Environment::PROJECT)
    p = Project.first
    all_attribs = data_to_array_of_hashes
    n = 1
    all_attribs.each do
      |a|
      wp = WorkPackage.find_by_position(a[:work_package])
      raise ActiveRecord::RecordNotFound, "Workpackage num. #{a[:work_package]} not found" unless wp
      m = Milestone.find_by_position(a[:milestone])
      a[:work_package] = wp
      a[:milestone] = m
      a[:project] = p
      @deliverables << Deliverable.create(a)
      n += 1
    end
    return @deliverables
  end

end
