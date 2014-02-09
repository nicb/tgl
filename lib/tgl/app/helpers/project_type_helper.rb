#
# $Id: project_type_helper.rb 2 2011-01-16 01:15:24Z nicb $
#
require File.dirname(__FILE__) + '/../models/work_package'

module ProjectTypeHelper

  class ProjectType

    class << self

  protected

      def used_fields
        []
      end

      def valid_activity?(act)
        used_fields.index(act)
      end

      def activity_color(act)
        valid_activity?(act) ? 'black' : 'lgray'
      end

  public

      ::WorkPackage::ACTIVITY_TYPES.each do
        |at|
        meth = "#{at.downcase}_activity_color"
        define_method(meth) { activity_color("#{at}") }
      end

    end

  end

  class STREPProjectType < ProjectType

    class << self

	    def used_fields
	      [ 'RTD', 'DEMO', 'MGMT' ]
	    end

    end

  end

  class CAProjectType < ProjectType

    class << self

	    def used_fields
	      [ 'COORD', 'MGMT', 'OTHER' ]
	    end

    end

  end

  class CSAProjectType < ProjectType

    class << self

	    def used_fields
	      [ 'SUPP', 'MGMT', 'OTHER' ]
	    end

    end

  end

  class Factory

    class << self

      def generate(t_acro)
        ('ProjectTypeHelper::' + t_acro + 'ProjectType').constantize
      end

    end

  end

end
