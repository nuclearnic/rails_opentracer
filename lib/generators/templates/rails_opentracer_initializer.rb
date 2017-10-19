require 'opentracing'
require 'zipkin'

if ENV.key?('ZIPKIN_SERVICE_URL')
  OpenTracing.global_tracer = Zipkin::Tracer.build(url: ENV['ZIPKIN_SERVICE_URL'], service_name: Rails.application.class.parent_name)
  ActiveRecord::RailsOpentracer.instrument(tracer: OpenTracing.global_tracer, active_span: -> { $active_span })
end
