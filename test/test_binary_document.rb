require 'helper'

class TestJsonDocument < MiniTest::Spec
  context "Ripple::Encryption::BinaryDocument" do
    setup do
      # # get some encryption going
      @config = Ripple::Encryption::Config.new ENV['ENCRYPTION']
      encryptor = Ripple::Encryption::Encryptor.new @config.to_h

      # this is the data package that we want
      @document = "some data goes here"

      # this is how we want that data package to actually be stored
      encrypted_value = encryptor.encrypt @document
      @encrypted_document = {:version => Ripple::Encryption::VERSION, :iv => Base64.encode64(@config.to_h['iv']), :data => encrypted_value}
    end

    should "convert a document to our desired BINARY format" do
      decrypted_document = Ripple::Encryption::EncryptedBinaryDocument.new(@config, @encrypted_document).decrypt
      assert_equal @document, decrypted_document, 'Decrypted BINARY document does not match original'
    end
  end

  context "Ripple::Encryption::BinaryDocument with no initialization vector" do
    setup do
      # this is the data package that we want
      @document = "some data goes here"

      # rig a BinaryDocument without an iv
      @config        = Ripple::Encryption::Config.new File.expand_path(File.join('..','fixtures','encryption_no_iv.yml'),__FILE__)
      @binary_document = Ripple::Encryption::BinaryDocument.new(@config, @document)
    end

    should "convert a document to our desired BINARY format and back again" do
      encrypted_document = @binary_document.encrypt
      assert_equal @document, Ripple::Encryption::EncryptedBinaryDocument.new(@config, encrypted_document).decrypt, 'Did not get the BINARY format expected.'
    end
  end
end
