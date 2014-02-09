#
# $Id: database.rb 2 2011-01-16 01:15:24Z nicb $
#
module Database

	thisdir = File.dirname(__FILE__)
	require thisdir + '/../config/environment'
	require thisdir + '/ec_reader'
	require thisdir + '/data_file'

  class <<self
	
    def create_structure
      ActiveRecord::Migrator.migrate(Environment.migration_dir)      
    end

    def populate
      DataFile::FILES.each do
        |df|
        klass = df.reader_class
        r = klass.new(df.csv_filename)
        r.load
      end
    end

	  def create(config) # only for sqlite
      db = config.clone
	    db['database'] = Environment.database_filename(config)
	    `#{db['adapter']} "#{db['database']}" 'create table x(x varchar(2)); drop table x;'` unless File.exists?(db['database'])
	    ActiveRecord::Base.establish_connection(db)
      create_structure
      Environment.load_app_objects
      populate
	  end

    def destroy(config) # only for sqlite
      File.unlink(Environment.database_filename(config))
    end
	
  end

end
