#
# $Id: work_package_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/../../lib/ec_reader/column_reader'

class WorkPackageReader < ColumnReader
  attr_reader :work_packages

private

  WORKPACKAGE_COLUMN_MAP =
  {
    'Workpackage Description' => :name,
    'Type of Activity' => :activity,
    'Lead Partic. No.' => :leader,
    'Start Month' => :start_month,
    'End Month' => :end_month,
    'Milestone' => :milestone,
  }

protected

  def self.column_hash
    return WORKPACKAGE_COLUMN_MAP
  end

public
  def initialize(df)
    super(df)
    @work_packages = []
  end

  def load
#   project = Project.find_by_acronym(Environment::PROJECT)
    project = Project.first
    all_attribs = data_to_array_of_hashes
    n = 1
    all_attribs.each do
      |a|
      leader = Partner.find_by_position(a[:leader])
      raise ActiveRecord::RecordNotFound, "Partner record num. #{a[:leader]} not found" unless leader
      a[:project] = project
      a[:leader] = leader
      a[:position] = n
      wp = WorkPackage.create(a)
      @work_packages << wp
      n += 1
    end
    return @work_packages
  end

end
