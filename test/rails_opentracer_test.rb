require "test_helper"
class RailsOpentracerTest < Minitest::Test
  # def test_child_of_using_span
  #   span = OpenTracing::Tracer.new.start_span('operation_name')
  #   reference = OpenTracing::Reference.child_of(span)
  #   assert_equal reference.type, OpenTracing::Reference::CHILD_OF
  #   assert_equal reference.context, span.context
  # end

  # def test_child_of_using_span_context
  #   context = OpenTracing::Tracer.new.start_span('operation_name').context
  #   reference = OpenTracing::Reference.child_of(context)
  #   assert_equal reference.type, OpenTracing::Reference::CHILD_OF
  #   assert_equal reference.context, context
  # end

  # def test_follows_from_using_span
  #   span = OpenTracing::Tracer.new.start_span('operation_name')
  #   reference = OpenTracing::Reference.follows_from(span)
  #   assert_equal reference.type, OpenTracing::Reference::FOLLOWS_FROM
  #   assert_equal reference.context, span.context
  # end

  # def test_follows_from_using_span_context
  #   context = OpenTracing::Tracer.new.start_span('operation_name').context
  #   reference = OpenTracing::Reference.follows_from(context)
  #   assert_equal reference.type, OpenTracing::Reference::FOLLOWS_FROM
  #   assert_equal reference.context, context

  # def test_that_it_has_a_version_number
  #   refute_nil ::RailsOpentracer::VERSION
  # end

  # def test_it_does_something_useful
  #   assert true
  #   # assert false
  # end
end
