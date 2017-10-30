module RailsOpentracer
  module SpanHelpers
    class << self
      def get(url)
        connection = Faraday.new do |con|
          con.use Faraday::Adapter::NetHttp
        end
        carrier = {}
        OpenTracing.inject(@span.context, OpenTracing::FORMAT_RACK, carrier)
        connection.headers = denilize(carrier)
        connection.get(url)
      end
    
      def with_span(name)
        @span =
          if $active_span.present?
            OpenTracing.start_span(name, child_of: $active_span)
          else
            OpenTracing.start_span(name)
          end
        yield if block_given?
        @span.finish
      end

      def set_error(span, exception)
        span.set_tag('error', true)

        case exception
        when Array
          exception_class, exception_message = exception
          span.log(event: 'error', :'error.kind' => exception_class, message: exception_message)
        when Exception
          span.log(event: 'error', :'error.object' => exception)
        end
      end
    end
  end
end
