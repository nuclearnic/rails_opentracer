require "test_helper"
require "minitest/autorun"
require "minitest/spec"
require "active_record"

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

  def test_do_query
    binding.pry
  end
end

