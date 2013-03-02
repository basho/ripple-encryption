require 'helper'

class TestConfig < MiniTest::Spec
  context "Ripple::Encryption::Config" do
    should 'confirm encryption is active' do
      assert Ripple::Encryption::Activation.activated?
    end

    should "raise heck if the config file isn't found" do
      assert_raises Ripple::Encryption::ConfigError do
        config = Ripple::Encryption::Config.new('nowhere')
      end
    end
  end
end
