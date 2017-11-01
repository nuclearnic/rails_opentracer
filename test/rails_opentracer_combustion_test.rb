require 'test_helper'
require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :all


class RailsOpentracerCombustionTest < Minitest::Test
  def test_opentracer_middleware_is_loaded
    assert Rails.application.middleware.include? RailsOpentracer::Middleware 
  end

  def test_global_tracer_present
    refute_nil OpenTracing.global_tracer
  end
  
  def test_get_request
    # ot = Class.new.extend(RailsOpentracer)
    
    # ot.with_span 'Calling books controller from app1' do
      # ot.get('http://google.com')
    # end
    # binding.pry
  end

end