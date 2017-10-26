# require 'opentracing'
# require 'zipkin'

# class Zipkin::JsonClient
#   # temporary monkey patch for a HTTPS related issue,
#   # remove this once fix has been made to
#   def emit_batch(spans)
#     return if spans.empty?

#     http = Net::HTTP.new(@spans_uri.host, @spans_uri.port)
#     http.use_ssl = true if @spans_uri.scheme == 'https'
#     puts "@spans_uri: #{@spans_uri} request_uri #{@spans_uri.request_uri}"
#     request = Net::HTTP::Post.new(@spans_uri.request_uri, {
#       'Content-Type' => 'application/json'
#     })
#     request.body = JSON.dump(spans)
#     response = http.request(request)

#     if response.code != 202
#       STDERR.puts(response.body)
#     end
#   rescue => e
#     STDERR.puts("Error emitting spans batch: #{e.message}\n#{e.backtrace.join("\n")}")
#   end
# end

# if ENV.key?('ZIPKIN_SERVICE_URL')
#   OpenTracing.global_tracer = Zipkin::Tracer.build(url: ENV['ZIPKIN_SERVICE_URL'], service_name: Rails.application.class.parent_name)
#   ActiveRecord::RailsOpentracer.instrument(tracer: OpenTracing.global_tracer, active_span: -> { $active_span })
# end
