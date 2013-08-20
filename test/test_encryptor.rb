require 'helper'

class TestEncryptor < MiniTest::Spec
  context "Ripple::Encryption Activate" do
    should "raise error if acivate using bad config path" do
      begin
        assert_raises Ripple::Encryption::ConfigError do                                                                                                                                          
          Riak::Serializers['application/x-json-encrypted'] = nil
          Ripple::Encryption.activate 'bad_path'
        end
      ensure
        assert_equal false, Ripple::Encryption.activated?
        Ripple::Encryption.activate ENV['ENCRYPTION']
        assert_equal true, Ripple::Encryption.activated?
      end
    end
  end

  context "Ripple::Encryption::Encryptor" do
    setup do
      config     = Ripple::Encryption::Config.new ENV['ENCRYPTION']
      @encryptor = Ripple::Encryption::Encryptor.new config.to_h
      # example text
      @text      = "This is some nifty text."
      # this is the example text encrypted (binary string literals use UTF-8 in ruby 2.0
      @blob      = "Vfn\xC3\xF1a\xB9\x89\x16\xCA\xD4w\xC4\xAF\x16\xA0c\xF7\xD0\x88\xA3;d\xC8Y\x91\xA8\x05W+)\xC8".force_encoding('ASCII-8BIT')
    end

    should "convert text to an encrypted blob" do
      assert_equal @blob, @encryptor.encrypt(@text), "Encryption failed."
    end

    should "convert encrypted blob to text" do
      assert_equal @text, @encryptor.decrypt(@blob), "Decryption failed."
    end
  end

  context "Ripple::Encryption::Encryptor with missing parameter" do
    should "raise an error if key is missing" do
      assert_raises Ripple::Encryption::EncryptorConfigError do
        Ripple::Encryption::Encryptor.new(:iv => 'iv', :cipher => 'AES-256-CBC')
      end
    end

    should "raise an error if iv is missing" do
      assert_raises Ripple::Encryption::EncryptorConfigError do
        Ripple::Encryption::Encryptor.new(:key => 'key', :cipher => 'AES-256-CBC')
      end
    end

    should "raise an error if cipher is missing" do
      assert_raises Ripple::Encryption::EncryptorConfigError do
        Ripple::Encryption::Encryptor.new(:key => 'key', :iv => 'iv')
      end
    end
  end
end
