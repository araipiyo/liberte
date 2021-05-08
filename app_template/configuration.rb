$:.unshift File.dirname(__FILE__).sub("app_template","lib") # まだgemになってないのでpathが…。

require 'sequel'
require 'liberte'
require_relative 'controllers'

$dburl = ""
$db = nil

def app
  liberte = Liberte::Handler.new(db: $db)
end

def run_main
#  Sequel.sqlite { |db|
    require_relative 'model' # modelはSequelに接続したあとに読み込む必要
    yield(app)
#  }
end
