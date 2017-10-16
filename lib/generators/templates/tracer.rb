require 'zipkin'

class Tracer
  def initialize(app)
    @app = app
  end

  def call(env)
    extracted_ctx = OpenTracing.extract(OpenTracing::FORMAT_RACK, env)
    span_name = get_span_name(env['REQUEST_PATH'])

    span =
      if extracted_ctx.nil?
        OpenTracing.start_span(span_name)
      else
        OpenTracing.start_span(span_name, child_of: extracted_ctx)
      end
    $active_span = span # yuck

    status, headers, response = @app.call(env)
    carrier = {}
    OpenTracing.inject(span.context, OpenTracing::FORMAT_RACK, carrier)
    span.finish

    [status, headers , response]
  end

  def get_span_name(request_path)
    Rails.application.routes.recognize_path(request_path).values.map { |i| i.to_s}.join(", ")
  end
end
