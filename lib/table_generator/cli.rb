#
# $Id: cli.rb 2 2011-01-16 01:15:24Z nicb $
#
require 'optparse'

require File.join(File.dirname(__FILE__), '..', 'tgl', 'lib', 'tg_wrapper')

module TableGenerator
  
  class CLI

    class << self

	    def execute(stdout, arguments=[])
	
	      # NOTE: the option -p/--path= is given as an example, and should be replaced in your application.
	
	      options = {
	        :path     => '~'
	      }
	      mandatory_options = %w(  )
	
	      parser = OptionParser.new do |opts|
	        opts.banner = <<-BANNER.gsub(/^          /,'')
	          tgl is a table generator gem for EC projects.
	          It actually generates all the latex tables required
	          by an EC project, plus gantt chart and other
	          amenities.
	
	          Usage: #{File.basename($0)}
	        BANNER
	        opts.separator ""
	        opts.on("-p", "--path PATH", String,
	                "This is a sample message.",
	                "For multiple lines, add more strings.",
	                "Default: ~") { |arg| options[:path] = arg }
	        opts.on("-h", "--help",
	                "Show this help message.") { stdout.puts opts; exit }
	        opts.parse!(arguments)
	
	        if mandatory_options && mandatory_options.find { |option| options[option.to_sym].nil? }
	          stdout.puts opts; exit
	        end
	      end
	
	      path = options[:path]
	
	      actually_do_some_work
	
	      stdout.puts "To update this executable, look in lib/table_generator/cli.rb"
	    end
	
	  private
	
	    def actually_do_some_work
				begin
					TgWrapper::start
					
					ecp = EcpController.new
					ecp.build_global_tables
				
				ensure
				  TgWrapper::stop
				end
	    end

    end

  end

end
