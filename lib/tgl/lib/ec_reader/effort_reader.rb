#
# $Id: effort_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/csv_reader'

class EffortReader < CsvReader
  attr_reader :efforts

public
  def initialize(df)
    super(df)
    @efforts = []
  end

  def load
    data[1..data.size].each do
      |line|
      attrs = {}
      attrs[:partner] = Partner.find_by_position(line[0])
      n = 1
      line[1..line.size].each do
        |wp|
        attrs[:work_package] = WorkPackage.find_by_position(n)
        attrs[:person_months] = wp
        @efforts << Effort.create(attrs)
        n += 1
      end
    end
    return @efforts
  end

end
