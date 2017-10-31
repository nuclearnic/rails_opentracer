require "rails/all"
require "pry"

require "combustion"
Combustion.path = "test/internal"
Combustion.initialize! :all

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rails_opentracer"
require "minitest/autorun"
