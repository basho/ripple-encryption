require 'helper'

class TestConfig < Test::Unit::TestCase
  context "Ripple::Encryption::Config" do
    should "raise heck if the config file isn't found" do
      assert_raise Ripple::Encryption::ConfigError do
        config = Ripple::Encryption::Config.new('nowhere')
      end
    end
  end
end
