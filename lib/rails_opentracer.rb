require 'rails_opentracer/active_record/rails_opentracer.rb'
require 'rails_opentracer/zipkin_config'
require 'rails_opentracer/span_helpers'
require 'rails_opentracer/middleware'
require 'rails_opentracer/version'
require 'opentracing'
require 'faraday'
require 'zipkin'

module RailsOpentracer
  def get(url)
    connection = Faraday.new do |con|
      con.use Faraday::Adapter::NetHttp
    end
    if ZipkinConfig.opentracer_enabled_and_zipkin_url_present?
      carrier = {}
      OpenTracing.inject(@span.context, OpenTracing::FORMAT_RACK, carrier)
      connection.headers = denilize(carrier)
    elsif ZipkinConfig.opentracer_enabled?
      Rails.logger.error 'TRACER_ERROR: `ZIPKIN_SERVICE_URL` environment variable is not defined'
    end
    connection.get(url)
  end

  def redirect(url)
    uri = URI(url)
    uri.query = {
      opentracer_trace_id: @span.context.trace_id,
      opentracer_parent_id: @span.context.span_id
    }.to_query
    redirect_to uri.to_s
  end

  def with_span(name)
    if ZipkinConfig.opentracer_enabled_and_zipkin_url_present? 
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
