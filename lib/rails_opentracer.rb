require 'rails_opentracer/active_record/rails_opentracer.rb'
require 'rails_opentracer/zipkin_config'
require 'rails_opentracer/span_helpers'
require 'rails_opentracer/middleware'
require 'rails_opentracer/version'
require 'opentracing'
require 'faraday'
require 'zipkin'

# TODO: use ZipkinConfig instead of these ENVs
# post requests ?

module RailsOpentracer
  def get(url)
    connection = Faraday.new do |con|
      con.use Faraday::Adapter::NetHttp
    end
    if ENV.key?('ZIPKIN_SERVICE_URL') && ENV.key?('RAILS_OPENTRACER_ENABLED') && ENV['RAILS_OPENTRACER_ENABLED'] == 'yes'
      carrier = {}
      OpenTracing.inject(@span.context, OpenTracing::FORMAT_RACK, carrier)
      connection.headers = denilize(carrier)
    elsif ENV.key?('RAILS_OPENTRACER_ENABLED') && ENV['RAILS_OPENTRACER_ENABLED'] == 'yes'
      Rails.logger.error 'TRACER_ERROR: `ZIPKIN_SERVICE_URL` environment variable is not defined'
    end
    connection.get(url)
  end

  def with_span(name)
    if ENV.key?('RAILS_OPENTRACER_ENABLED') && ENV['RAILS_OPENTRACER_ENABLED'] == 'yes'
      @span =
        if $active_span.present?
          OpenTracing.start_span(name, child_of: $active_span)
        else
          OpenTracing.start_span(name)
        end
      yield if block_given?
      @span.finish
    else
      yield if block_given?
    end
  end

  private
  def denilize(hash)
    hash.each { |k, _v| hash[k] = '' if hash[k].nil? }
  end
end
