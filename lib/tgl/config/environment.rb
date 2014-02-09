#
# $Id: environment.rb 5 2011-01-16 15:16:22Z nicb $
#

module Environment

  class <<self

	  def gemdir
	    return `gem environment gemdir`.chomp + '/gems'
	  end
	
	  def topdir
	    result = File.join(File.dirname(__FILE__), '..', '..', '..')
	    ENV['TGL_ROOT'] = result unless ENV['TGL_ROOT']
	    result
	  end

    def tgl_topdir
      File.join(topdir, 'lib', 'tgl')
    end

    def specific_gem_dir(object)
      File.join(gemdir, object + '-' + Rails::VERSION::STRING)
    end

    def db_dir
      File.join(tgl_topdir, 'db')
    end
	
    def migration_dir
      File.join(db_dir, 'migrate')
    end

    def log_dir
      File.join(topdir, 'log')
    end

    def data_dir
      File.join(topdir, 'input')
    end

    def fixture_dir
      #
      # this can't be derived from data_dir because in the testing
      # environment it gets aliased to it
      #
      File.join(topdir, 'input', 'examples')
    end

    def admin_dir
      File.join(topdir, 'output')
    end

    alias :output_dir :admin_dir

    def app_dir
      File.join(tgl_topdir, 'app')
    end

    def views_dir
      File.join(app_dir, 'views')
    end

    def share_dir
      File.join(tgl_topdir, 'share')
    end

	  def set_up
      ['activerecord', 'activesupport', 'actionpack'].each do
        |hier|
	      $: << specific_gem_dir(hier) + '/lib'
      end
	  end
	
	  def configuration_file
      File.join(tgl_topdir, 'config', 'databases.yml')
	  end
	
	  def load_configurations
	    ActiveRecord::Base.configurations = YAML.load(File.open(configuration_file, 'r'))
	  end

    def load_app_objects
      ['helpers', 'models', 'controllers'].each do
        |dir|
        objs = Dir.glob(app_dir + '/' + dir + '/*.rb')
        objs.each { |f| require f.sub(/\.rb$/,'') }
      end
    end

    def database_filename(config)
      File.join(db_dir, config['database'])
    end
	
  end

end

module Rails

  module VERSION
    STRING = `rails --version`.chomp.gsub(/Rails /,'') unless defined?(STRING)
  end

  class << self

    def logfile
      File.join(Environment.log_dir, 'tgwrapper.log')
    end
  
  
    def logger
      ActiveRecord::Base.logger = Logger.new(logfile)
    end

  end

end
