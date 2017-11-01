require 'test_helper'
require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :all

# STUFF:
# Combustion::Application
#  p = Combustion::Application::PagesController.new
#  p.index
# example of payload consumed by activerecord sql method
# {:sql=>"PRAGMA foreign_keys = ON", :name=>"SCHEMA", :binds=>[], :type_casted_binds=>[], :statement_name=>nil, :connection_id=>70189528217600} 

# TODO: WHEN ENV is test then don't ping zipkin client url
# 
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
    args = ["","","","", {:sql=>"", :name=>"", :connection_id=>12345} ]
    refute_nil ActiveRecord::RailsOpentracer.sql(args: args)
  end

  # def get_span_from_engine
  #   p = Combustion::Application::PagesController.new
  #   span = p.index
  # end

end