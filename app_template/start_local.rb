require_relative 'configuration'
require 'webrick'

run_main { |db|
  liberte = Liberte::Handler.new(db: db)
  Rack::Handler::WEBrick.run(liberte)
}
