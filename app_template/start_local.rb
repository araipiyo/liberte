require_relative 'configuration'
require 'webrick'

run_main { |app|
  Rack::Handler::WEBrick.run(app)
}
