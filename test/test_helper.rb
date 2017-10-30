require "rails/all"
require "pry"

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "rails_opentracer"
require "minitest/autorun"
