require 'OpenTracing'
require 'Zipkin'
require 'Rails'

OpenTracing.global_tracer = Zipkin::Tracer.build(url: ENV['ZIPKIN_SERVICE_URL'], service_name: Rails.application.class.parent_name)
