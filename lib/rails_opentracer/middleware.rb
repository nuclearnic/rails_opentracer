require 'zipkin'
require 'rails_opentracer/zipkin_config'

module RailsOpentracer
  class Railtie < Rails::Railtie
    initializer 'rails_opentracer.configure_rack_middleware' do
      Rails.application.middleware.use Middleware
    end
    initializer 'rails_opentracer.configure_initializer' do
      # temporary monkey patch for a HTTPS related issue,
      # remove this once fix has been made to
      class ::Zipkin::JsonClient
        def emit_batch(spans)
          return if spans.empty?

          http = Net::HTTP.new(@spans_uri.host, @spans_uri.port)
          http.use_ssl = true if @spans_uri.scheme == 'https'
          puts "@spans_uri: #{@spans_uri} request_uri #{@spans_uri.request_uri}"
          request = Net::HTTP::Post.new(@spans_uri.request_uri, {
            'Content-Type' => 'application/json'
          })
          request.body = JSON.dump(spans)
          response = http.request(request)

          if response.code != 202
            Rails.logger.error("Error initialising Zipkin, expected response code, but received #{response.code}. Body: #{response.body}")
          end
        rescue => e
          Rails.logger.error("Error emitting spans batch: #{e.message}\n#{e.backtrace.join("\n")}")
        end
      end
      if ZipkinConfig.opentracer_enabled_and_zipkin_url_present?
        OpenTracing.global_tracer = Zipkin::Tracer.build(url: ZipkinConfig.zipkin_url, service_name: Rails.application.class.parent_name)
        ActiveRecord::RailsOpentracer.instrument(tracer: OpenTracing.global_tracer, active_span: -> { $active_span })
      end
    end
  end

  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      span = nil
      if ZipkinConfig.opentracer_enabled_and_zipkin_url_present?
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
      else
        if ZipkinConfig.opentracer_enabled? 
          Rails.logger.error 'TRACER_ERROR: `ZIPKIN_SERVICE_URL` environment variable is not defined'
        end
        return @app.call(env)
      end
    end

    def error_message(e)
      "#{e}\n#{e.backtrace[0, 10].join("\n\t")}"
    end
  end
end
