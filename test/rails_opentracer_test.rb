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

  # def test_rspec_stuff
  #   describe "bleh" do
  #       x = 1
  #       y = 2
  #      assert_equal(x, y) 
  #   end
  # end

end
