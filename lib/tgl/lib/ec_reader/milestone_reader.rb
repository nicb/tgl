#
# $Id: milestone_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/../../lib/ec_reader/column_reader'

class MilestoneReader < ColumnReader
  attr_reader :milestones

private

  MILESTONE_COLUMN_MAP =
  {
    'N.' => :position,
    'Milestone name' => :name,
    'Wps involved' => :not_used,
    'Delivs involved' => :not_used,
    'Date (month)' => :month,
  }

protected

  def self.column_hash
    return MILESTONE_COLUMN_MAP
  end

public

  def initialize(df)
    super(df)
    @milestones = []
  end

  def load
#   p = Project.find_by_acronym(Environment::PROJECT)
    p = Project.first
    all_attribs = data_to_array_of_hashes
    n = 1
    all_attribs.each do
      |a|
      a.delete(:not_used)
      a[:project] = p
      @milestones << Milestone.create(a)
      n += 1
    end
    return @milestones
  end

end
