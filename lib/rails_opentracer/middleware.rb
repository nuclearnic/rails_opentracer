require 'zipkin'

module RailsOpentracer
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      span = nil
      begin
        extracted_ctx = OpenTracing.extract(OpenTracing::FORMAT_RACK, env)
        span_name = env['REQUEST_PATH']
        span =
          if extracted_ctx.nil?
            OpenTracing.start_span(span_name)
          else
            OpenTracing.start_span(span_name, child_of: extracted_ctx)
          end
        $active_span = span # yuck
      rescue StandardError => e
        Rails.logger.error "TRACER_ERROR: #{error_message(e)}"
        return @app.call(env)
      end

      status, headers, response = @app.call(env)

      begin
        carrier = {}
        OpenTracing.inject(span.context, OpenTracing::FORMAT_RACK, carrier)
        span.finish
        [status, headers , response]
      rescue StandardError => e
        Rails.logger.error "TRACER_ERROR: #{error_message(e)}"
        [status, headers, response]
      end
    end

    def error_message(e)
      "#{e}\n#{e.backtrace[0, 10].join("\n\t")}"
    end
  end
end
