require "test_helper"
require "minitest/spec"

class RailsOpentracerTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::RailsOpentracer::VERSION
  end

  def rspec_like_test
    describe "bleh" do
      it "does something" do
        x = 1
        y = 2
        expect(x).to eq(y)
      end
    end
  end

end

