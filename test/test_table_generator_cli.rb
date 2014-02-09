#
# $Id: test_table_generator_cli.rb 5 2011-01-16 15:16:22Z nicb $
#
require File.join(File.dirname(__FILE__), "test_helper.rb")
require 'table_generator/cli'

class TestTableGeneratorCli < Test::Unit::TestCase

  def setup
    TableGenerator::CLI.execute(@stdout_io = StringIO.new, [])
    @stdout_io.rewind
    @stdout = @stdout_io.read
  end

  def teardown
    assert output_files = Dir.glob(File.join(Environment.output_dir, '*'))
    output_files.each { |f| assert File.unlink(f) }
    assert output_files = Dir.glob(File.join(Environment.output_dir, '*'))
    assert output_files.empty?
  end
  
  def test_print_default_output
    assert_match(/To update this executable/, @stdout)
  end

end
