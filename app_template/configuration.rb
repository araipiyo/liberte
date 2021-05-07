$:.unshift File.dirname(__FILE__).sub("app_template","lib") # まだgemになってないのでpathが…。

require 'sequel'
require 'liberte'
require_relative 'controllers'

def run_main
#  Sequel.sqlite { |db|
    require_relative 'model' # modelはSequelに接続したあとに読み込まないといけない
    yield(nil)
#  }
end
