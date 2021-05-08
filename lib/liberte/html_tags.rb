require 'active_support/all' # ActiveSupport::SafeBufferの機能を使います

module Liberte
  module HTMLTags
    class <<self
      def escape_html(s)
        s.html_safe? ? s : CGI.escapeHTML(s.to_s).html_safe
      end
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
      def tag_solo(name, attributes = {})
        _tag(name, :solo, attributes)
      end
      def tag_open(name, attributes = {})
        _tag(name, :open, attributes)
      end
      def tag_close(name, attributes = {})
        _tag(name, :close, attributes)
      end
      def tag(tag, s, attributes = {})
        tag_open(tag, attributes) + escape_html(s) + tag_close(tag, {})
      end
      %w[br hr link img input meta].each { |t|
        define_method(t) { |attr = {}| tag_solo(t, attr) }
      }
      %w[h1 h2 h3 h4 h5 h6 b i p html body head big small form table textarea tbody td th tr pre label].each { |t|
        define_method(t) { |s, attr = {}|
          tag(t, s, attr)
        }
      }
      def a(url, s, attr = {})
        tag('a', s, {href: url}.merge(attr))
      end
      def li(array)
        array.map{ |s| "<li>#{escape_html(s)}</li>" }.join("\n")
      end
      def ol(array)
        "<ol>#{li(array)}</ol>"
      end
      def ul(array)
        "<ul>#{li(array)}</ul>"
      end
    end
  end
end
