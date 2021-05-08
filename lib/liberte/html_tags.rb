require 'active_support/all' # ActiveSupport::SafeBufferの機能を使います

module Liberte
  # HTMLのタグをコードから作成するためのモジュール
  module HTMLTags
    class <<self
      # エスケープ済みでない文字列をエスケープする
      def escape_html(s)
        s.html_safe? ? s : CGI.escapeHTML(s.to_s).html_safe
      end
      # 内部利用。タグを生成する
      def _tag(name , soc, attributes)
        close = soc == :close ? '/' : ''
        solo = soc == :solo ? '/' : ''
        
        atr = if attributes and not attributes.empty?
          s = attributes.map { |k,v| "#{escape_html(k)}='#{escape_html(v)}'" }.join(' ')
          " #{s}"
        else
          ""
        end
        "<#{close}#{escape_html(name)}#{atr}#{solo}>".html_safe
      end
      # <br/>のような単独タグを作成する
      def tag_solo(name, attributes = {})
        _tag(name, :solo, attributes)
      end
      # 開きタグを生成する
      def tag_open(name, attributes = {})
        _tag(name, :open, attributes)
      end
      # 閉じタグを生成する
      def tag_close(name, attributes = {})
        _tag(name, :close, attributes)
      end
      # 内部要素を含んだタグを生成する
      # tag("p", "Hello World!")などと使う。
      def tag(tag, s, attributes = {})
        tag_open(tag, attributes) + escape_html(s) + tag_close(tag, {})
      end
      # 単独タグの利便性を高めるメソッド tags.brなどと呼び出せるようになる。
      %w[br hr link img input meta].each { |t|
        define_method(t) { |attr = {}| tag_solo(t, attr) }
      }
      # タグの利便性を高めるメソッド tags.p(tags.br)などと呼び出せるようになる。
      %w[h1 h2 h3 h4 h5 h6 b i p html body head big small form table textarea tbody td th tr pre label].each { |t|
        define_method(t) { |s, attr = {}| tag(t, s, attr) }
      }
      # aタグを作る。URLが簡単に指定できるよ。
      def a(url, s, attr = {})
        tag('a', s, {href: url}.merge(attr))
      end
      def li(array)
        array.map{ |s| "<li>#{escape_html(s)}</li>" }.join("\n").html_safe
      end
      def ol(array)
        "<ol>#{li(array)}</ol>".html_safe
      end
      def ul(array)
        "<ul>#{li(array)}</ul>".html_safe
      end
    end
  end
end
