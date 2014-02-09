#
# $Id: test_helper.rb 2 2011-01-16 01:15:24Z nicb $
#
require File.dirname(__FILE__) + '/../lib/tg_wrapper'
require File.dirname(__FILE__) + '/../lib/tg_debugger'
require 'test/unit'
MODELS_PATH = File.dirname(__FILE__) + '/../app/models'
$: << MODELS_PATH

TgWrapper.start
ActiveRecord::Base.establish_connection(:database)
#Dir.glob(MODELS_PATH + '/*.rb').each { |f| require f }
