#
# $Id: active_controller.rb 2 2011-01-16 01:15:24Z nicb $
#

require 'erb'

module ActiveController

  class ActiveControllerError < StandardError
  end

  class Base

  protected

    def get_binding
      return binding
    end

  end

end
