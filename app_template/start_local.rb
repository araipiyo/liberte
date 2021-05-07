require_relative 'configuration'
require 'webrick'

run_main { |db|
  liberte = Liberte::Handler.new(db: db)
  reloader = Rack::Reloader.new(liberte,1)
  Rack::Handler::WEBrick.run(reloader)
}
