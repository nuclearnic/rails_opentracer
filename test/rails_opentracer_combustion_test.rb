require 'test_helper'
require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :all

# STUFF:
# Combustion::Application
#  p = Combustion::Application::PagesController.new
#  p.index

# TODO:
# WHEN ENV is test then don't ping zipkin client url

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

  # def get_span_from_engine
  #   p = Combustion::Application::PagesController.new
  #   span = p.index
  # end

end