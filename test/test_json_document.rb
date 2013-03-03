require 'helper'

class TestJsonDocument < MiniTest::Spec
  context "Ripple::Encryption::JsonDocument" do
    setup do
      # get some encryption going
      @config    = Ripple::Encryption::Config.new ENV['ENCRYPTION']
      encryptor = Ripple::Encryption::Encryptor.new @config.to_h

      # this is the data package that we want
      @document = {'some' => 'data goes here'}

      # this is how we want that data package to actually be stored
      encrypted_value = encryptor.encrypt JSON.dump @document
      @encrypted_document = JSON.dump({:version => Ripple::Encryption::VERSION, :iv => Base64.encode64(@config.to_h['iv']), :data => Base64.encode64(encrypted_value)})
    end

    should "convert a document to our desired JSON format" do
      assert_equal @encrypted_document, Ripple::Encryption::JsonDocument.new(@config, @document).encrypt, 'Did not get the JSON format expected.'
    end

    should "interpret our JSON format into a document" do
      assert_equal @document, Ripple::Encryption::EncryptedJsonDocument.new(@config, @encrypted_document).decrypt, 'Did not get the JSON format expected.'
    end
  end

  context "Ripple::Encryption::JsonDocument with no initialization vector" do
    setup do
      # this is the data package that we want
      @document = {'some' => 'data goes here'}

      # rig a JsonDocument without an iv
      @config        = Ripple::Encryption::Config.new File.expand_path(File.join('..','fixtures','encryption_no_iv.yml'),__FILE__)
      @json_document = Ripple::Encryption::JsonDocument.new(@config, @document)
    end

    should "convert a document to our desired JSON format and back again" do
      encrypted_document = @json_document.encrypt
      assert_equal @document, Ripple::Encryption::EncryptedJsonDocument.new(@config, encrypted_document).decrypt, 'Did not get the JSON format expected.'
    end
  end
end
