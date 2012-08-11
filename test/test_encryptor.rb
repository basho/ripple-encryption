require 'helper'

class TestEncryptor < Test::Unit::TestCase
  context "Ripple::Encryption::Encryptor" do
    setup do
      config     = Ripple::Encryption::Config.new ENV['ENCRYPTION']
      @encryptor = Ripple::Encryption::Encryptor.new config.to_h
      # example text
      @text      = "This is some nifty text."
      # this is the example text encrypted
      @blob      = "Vfn\xC3\xF1a\xB9\x89\x16\xCA\xD4w\xC4\xAF\x16\xA0c\xF7\xD0\x88\xA3;d\xC8Y\x91\xA8\x05W+)\xC8"
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
      assert_raise Ripple::Encryption::EncryptorError do
        Ripple::Encryption::Encryptor.new(:iv => 'iv', :cipher => 'AES-256-CBC')
      end
    end

    should "raise an error if iv is missing" do
      assert_raise Ripple::Encryption::EncryptorError do
        Ripple::Encryption::Encryptor.new(:key => 'key', :cipher => 'AES-256-CBC')
      end
    end

    should "raise an error if cipher is missing" do
      assert_raise Ripple::Encryption::EncryptorError do
        Ripple::Encryption::Encryptor.new(:key => 'key', :iv => 'iv')
      end
    end
  end
end
