require 'test_helper'
# require 'minitest/autorun'
require 'minitest/spec'
# require 'active_record'

# TODO: when including RailsOpentracer (below) connection to Zipkin client fails (obviously)
# include RailsOpentracer 
# ENVs required in gem
# ENV['RAILS_OPENTRACER_ENABLED']
# ENV['ZIPKIN_SERVICE_URL']


class RailsOpentracerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RailsOpentracer::VERSION
  end


  # # TODO: 4x tests for all ENVs combos
  # def test_active_record_query
  #   page = Page.first
  #   # binding.pry
  # end

  # def test_loading_of_opentracer_middleware
  #   # binding.pry
  #   Rails.application.middleware.include? RailsOpentracer::Middleware 
  # end

  # def test_rspec_stuff
  #   describe "bleh" do
  #       x = 1
  #       y = 2
  #      assert_equal(x, y) 
  #   end
  # end

  # def test_do_query
  #   binding.pry
  # end
end

# class ZipkinConfigNotPresentError < StandardError
# end