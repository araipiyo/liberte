require 'active_support/all'

module Liberte
  # コントローラーの親クラス。これを継承してコントローラーを定義する。
  class Controller
    attr_reader :db
    @@routing_table = {}
    def initialize(req, params, opts)
      @opts = opts
      @db = opts[:db]
      @req = req
    end
    
    # ERBを呼ぶ。テンプレート名を指定するだけ。XSS対策が弱いのでお勧めしない。
    def erb(template_name)
      erb = ERB.new(File.read("templates/#{template_name.to_s}.erb"))
      erb.filename = template_name.to_s
      html(erb.result(binding).html_safe)
    end
    # HTMLタグを作るヘルパー
    def tags
      Liberte::HTMLTags
    end
    # HTMLレスポンスを作る
    def html(s)
      [200, {'Content-Type' => 'text/html'}, [s]]
    end
    # リダイレクトを行うレスポンスを作る。これを返すことでリダイレクト可能
    def permanent_redirect(url)
      [301, {location: url}, []]
    end
    def temporary_redirect(url)
      [302, {location: url}, []]
    end
    alias redirect temporary_redirect
    # 内部的に別のコントローラーを呼び出して結果を得る
    def call(path, params)
      (ctrl_class, action, path_params) = Controller.find_controller(path)
      return ctrl_class.new(@req, params, @opts).instance_exec(*path_params, &action)
    end
    # アクションを定義する
    # get "/foo/bar/%%/%%" { |a,b| hoge }
    # post %r|/foo/bar/(a|b|c)| { |a| hoge }
    # 子クラスで上記のように呼び出してアクションとパスを定義する。
    class <<self
      %w[get head post put delete options patch].each { |s|
        define_method(s) { |path, &block|
          @@routing_table[path] = [self, block, s.upcase]
        }
      }
    end
    # before_filterを定義する。レスポンスを返せば動作が変わる
    def before_filter
      nil
    end
    # after_filterを定義する。rack形式レスポンスを受け取って、それを変更可能
    def after_filter(rack_result)
      rack_result
    end

    # 以下は内部利用用
    # ルーティングする。定義されたパスからマッチするものを探して返す。
    def self.find_controller(path, method = 'GET')
      @@routing_table.each { |k,v|
        k = Regexp.new("\\A" + k.gsub(/%%/, "(.+?)") + "\\z") if k.is_a?(String)
        match_data = k.match(path)
        next unless match_data
        next unless v[2] == method
        return [v[0], v[1], match_data.captures]
      }
      return nil
    end
  end
end
