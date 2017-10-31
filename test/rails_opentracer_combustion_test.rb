require 'test_helper'
require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :all


class RailsOpentracerCombustionTest < Minitest::Test
  def test_that_it_has_a_version_number
    puts 'yyyyyyyyyyyyyyyyyyyyy'
  end
end