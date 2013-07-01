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
      another_encrypted_document = Ripple::Encryption::JsonDocument.new(@config, @document).encrypt

      assert another_encrypted_document != @encrypted_document, "Documents have same cipher text, iv may not be unique"

      assert (JSON.parse another_encrypted_document).has_key?('version'), 'Did not have a version attribute'
      assert (JSON.parse another_encrypted_document).has_key?('iv'), 'Did not have a iv attribute'
      assert (JSON.parse another_encrypted_document).has_key?('data'), 'Did not have a data attribute'

      decrypted_document = Ripple::Encryption::EncryptedJsonDocument.new(@config, @encrypted_document).decrypt

      assert_equal @document, decrypted_document, 'Decrypted JSON document does not match original'
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
