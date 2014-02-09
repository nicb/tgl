#
# $Id: project_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/csv_reader'

class ProjectReader < CsvReader
  attr_reader :project

private

  PROJECT_COLUMN_MAP =
  {
    'Title' => :title,
    'Acronym' => :acronym,
    'ICT Call No.' => :ict_call_no,
    'Year' => :year,
    'Call' => :call,
    'Type' => :project_type,
    'Type (acronym)' => :type_acro,
    'Challenge' => :challenge,
    'Topics (FP7 ICT WorkPr)' => :topic,
    'Duration' => :duration,
    'Proposal Number' => :proposal_number,
  }

protected

  def self.column_hash
    return PROJECT_COLUMN_MAP
  end

public

  def initialize(df)
    super(df)
  end

  def load
    attribs = {}
    data.each { |l| attribs[self.class.column_mapper(l[0])] = l[1] }
    @project = Project.create(attribs) 
  end

end
