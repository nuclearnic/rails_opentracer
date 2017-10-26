require 'rails_opentracer/active_record/rails_opentracer.rb'
require 'rails_opentracer/span_helpers'
require 'rails_opentracer/version'
require 'rails_opentracer/middleware'
require 'faraday'
require 'opentracing'
require 'zipkin'

module RailsOpentracer
  class << self
    def instrument(tracer: OpenTracing.global_tracer, active_span: nil, active_record: true)
      ActiveRecord::RailsOpentracer.instrument(tracer: tracer, active_span: active_span) if active_record
    end

    def disable
      ActiveRecord::RailsOpentracer.disable
    end
  end

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
  # BELOW WE ARE ATTEMPTING TO NOT USE GENERATORS SO THIS
  # SHOULD EVENTUALLY GO INTO A SEPERATE FILE IF IT WORKS
  class Railtie < Rails::Railtie
    initializer 'rails_opentracer.configure_rack_middleware' do
      Rails.application.middleware.use RailsOpentracer::Middleware
    end
    initializer 'rails_opentracer.configure_initializer' do
      # temporary monkey patch for a HTTPS related issue,
      # remove this once fix has been made to
        class ::Zipkin::JsonClient
          def emit_batch(spans)
            return if spans.empty?
        
            http = Net::HTTP.new(@spans_uri.host, @spans_uri.port)
            http.use_ssl = true if @spans_uri.scheme == 'https'
            # puts "@spans_uri: #{@spans_uri} request_uri #{@spans_uri.request_uri}"
            request = Net::HTTP::Post.new(@spans_uri.request_uri, {
              'Content-Type' => 'application/json'
            })
            request.body = JSON.dump(spans)
            response = http.request(request)
        
            if response.code != 202
              STDERR.puts(response.body)
            end
          rescue => e
            STDERR.puts("Error emitting spans batch: #{e.message}\n#{e.backtrace.join("\n")}")
          end
        end
        if ENV.key?('ZIPKIN_SERVICE_URL')
          OpenTracing.global_tracer = Zipkin::Tracer.build(url: ENV['ZIPKIN_SERVICE_URL'], service_name: Rails.application.class.parent_name)
          ActiveRecord::RailsOpentracer.instrument(tracer: OpenTracing.global_tracer, active_span: -> { $active_span })
        end
      end
    end
  end

  private

  def denilize(hash)
    hash.each { |k, _v| hash[k] = '' if hash[k].nil? }
  end
end
