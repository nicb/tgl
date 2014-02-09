#
# $Id: tg_wrapper.rb 2 2011-01-16 01:15:24Z nicb $
#

require File.dirname(__FILE__) + '/database'

module TgWrapper

  class <<self

    def logfile
      return Environment.log_dir + '/tgwrapper.log'
    end

	  def start
	    Environment.set_up
	    require('active_record')
      ActiveRecord::Base.logger = Logger.new(logfile)
	    Environment.load_configurations
	    ActiveRecord::Base.configurations.each_value do
	      |db|
	      next unless db['database']
	      Database.create(db)
	    end
	  end

    def stop
	    ActiveRecord::Base.configurations.each_value do
	      |db|
	      Database.destroy(db)
	    end
    end
	
  end

end
