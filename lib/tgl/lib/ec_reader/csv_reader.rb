#
# $Id: csv_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require 'csv'

class CsvReader
  attr_reader :datafile, :data

  def initialize(df)
    @datafile = df
    @data = []
    reader = CSV.open(@datafile, 'r')
    reader.map { |l| @data << l }
  end

protected

  class <<self
	  def column_hash
      return nil
    end
	
	  def column_mapper(key)
	    return column_hash.has_key?(key) ? column_hash[key] : key
	  end
  end

end
