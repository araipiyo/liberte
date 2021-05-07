require 'rack'
require 'active_support'
require 'active_support/all'
require 'cgi/escape'
require 'cgi/util'

module Liberte
  # HandlerはRackから呼ばれるメソッド(call)を定義する。最初に呼ばれるクラス
  class Handler
    def display_internal_server_error(e)
      html = "<html><body><h1>Internal server error.</h1><p>Exception: " +
       CGI.escape_html(e.to_s) + "</p><h2>Back trace</h2><p>" +
       e.backtrace.map{|s|CGI.escape_html(s)}.join("<br/>")+"</p></body></html>"
      [500, {'Content-Type' => 'text/html'}, [html]]
    end
    public
    # newで初期設定を渡してインスタンスを作成する必要があります。
    def initialize(opts)
      @opts = opts
    end
    # Rackからリクエストがあると呼ばれるメソッド。エントリポイント。
    def call(rack_env)
      req = Rack::Request.new(rack_env) # Rackリクエストを取得
      begin
        # リクエストパラメータをシンボルにする。利便性向上のため。
        params = req.params.deep_symbolize_keys
        # コントローラーを見つける
        (ctrl_cls, action, path_params) = 
          Controller.find_controller(req.path, req.request_method)
        # アクションを呼び出す (ctrlインスタンスのスコープ内で呼ぶ)
        result = unless ctrl_cls
          [404, {}, ["404 Not Found"]]
        else
          opts = @opts.merge({path_params: path_params})
          ctrl = ctrl_cls.new(req, params, opts)
          ctrl.before_filter || ctrl.instance_exec(*path_params, &action)
        end
        rack_result = case result
          when Array then result # 結果が配列ならRack形式とみなす
          when String then [200, {}, [result]] # 文字列なら200
          else [200, {}, [result.to_s]]
        end
        rack_result = ctrl.after_filter(rack_result) if ctrl
        return rack_result
      rescue Exception => e
        # 捕捉したエラーをログに出力する。
        @opts[:error_logger]&.write(e) rescue nil
        # エラーをHTTPレスポンスに出力する。
          # todo: テンプレート対応
        return display_internal_server_error(e)
      end
    end
  end
end

