require 'test_helper'
require 'minitest/spec'

class RailsOpentracerTest < Minitest::Test
  
  def test_that_it_has_a_version_number
    refute_nil ::RailsOpentracer::VERSION
  end
end
