require 'rails_opentracer/version'
require 'faraday'

module RailsOpentracer
  def get(url)
    connection = Faraday.new do |con|
      con.use FaradayTracer
      con.use Faraday::Adapter::NetHttp
    end

    carrier = {}
    OpenTracing.inject(@span.context, OpenTracing::FORMAT_RACK, carrier)
    connection.headers = denilize(carrier)
    response = connection.get(url)
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

  def denilize(hash)
    hash.each {|k,v| hash[k] = "" if hash[k].nil?}
  end
end
