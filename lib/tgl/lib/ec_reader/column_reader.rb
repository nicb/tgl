#
# $Id: column_reader.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/../../lib/ec_reader/csv_reader'

class ColumnReader < CsvReader

  def initialize(df)
    super(df)
  end

protected

  def data_to_array_of_hashes
    result = []
    n = 0
    keys = data[0]
    data.shift
    data.each do
      |d|
      attribs = {}
      keys.each_index { |i| attribs[self.class.column_mapper(keys[i])] = d[i] }
      result[n] = attribs
      n += 1
    end
    return result
  end

end
