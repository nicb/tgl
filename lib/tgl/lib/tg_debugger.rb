#
# $Id: tg_debugger.rb 2 2011-01-16 01:15:24Z nicb $
#
# add a debugger trace wherever you load this file
#
require 'rubygems'
require 'active_support'
begin
  require_library_or_gem 'ruby-debug'
  ::Debugger.start
  ::Debugger.settings[:autoeval] = true if ::Debugger.respond_to?(:settings)
rescue LoadError
  # ruby-debug wasn't available so neither can the debugging be
  puts("could not load the debugger")
end
