#
# $Id: data_file.rb 4 2011-01-16 02:45:45Z nicb $
#
require File.dirname(__FILE__) + '/../config/environment'
require File.dirname(__FILE__) + '/ec_reader'

Environment::set_up

require 'active_support'

class DataFile
  attr_reader :name, :csvname

  def initialize(name, csv)
    @name = name
    @csvname = csv
  end

  def csv_filename
    result = Dir.glob(Environment::data_dir + "/[0-9][0-9]_#{csvname}.csv").first
    result = Dir.glob(Environment::fixture_dir + "/[0-9][0-9]_#{csvname}.csv").first unless result && !result.empty?
    raise FileNotFound unless File.exists?(result)
    result
  end

  def reader_class
    return (name + '_reader').camelize.constantize
  end

  FILES =
  [
    DataFile.new('project', 'projectdata'),
    DataFile.new('partner', 'partnerdata'),
    DataFile.new('milestone', 'milestones'),
    DataFile.new('work_package', 'workpackages'),
    DataFile.new('effort', 'effort'),
    DataFile.new('deliverable', 'deliverables'),
    DataFile.new('skill', 'skills'),
  ]

end
