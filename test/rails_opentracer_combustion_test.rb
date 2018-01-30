require 'test_helper'
require 'combustion'
Combustion.path = 'test/internal'
Combustion.initialize! :all

class RailsOpentracerCombustionTest < Minitest::Test
  def test_opentracer_middleware_is_loaded
    assert Rails.application.middleware.include? RailsOpentracer::Middleware
  end

  def test_global_tracer_present
    refute_nil OpenTracing.global_tracer
  end

  def test_get_request_has_span
    test_controller = Combustion::Application::PagesController.new
    span = test_controller.index
    refute_nil span
  end

  def test_active_record_query_creates_span
    args = ['', '', '', '', { sql: '', name: '', connection_id: 123 }]
    refute_nil ActiveRecord::RailsOpentracer.sql(args: args)
  end
end
