require 'rails_opentracer/active_record/rails_opentracer.rb'
require 'rails_opentracer/span_helpers'
require 'rails_opentracer/version'
require 'rails_opentracer/middleware'
require 'faraday'

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
    initializer "rails_opentracer.configure_rails_initialization" do
      Rails.application.middleware.use RailsOpentracer::Middleware
    end
  end

  private

  def denilize(hash)
    hash.each {|k,v| hash[k] = "" if hash[k].nil?}
  end
end
