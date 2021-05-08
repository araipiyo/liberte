require 'irb'
require 'rack/test'

module Fixture
  include Rack::Test::Methods
  
  def app
    TOPLEVEL_BINDING.app
  end
end

if ARGV[0]
  run_main { |db|
    $db = db
    include Fixture
    _get(ARGV[0])
  }
else
  run_main { |db|
    $db = db
    include Fixture
    IRB.start
  }
end
