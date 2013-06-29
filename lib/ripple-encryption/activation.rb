require 'openssl'
require 'ripple'

module Ripple
  module Encryption

    # When mixed into a Ripple::Document class, this will encrypt the
    # serialized form before it is stored in Riak.  You must register
    # a serializer that will perform the encryption.
    # @see Serializer
    extend ActiveSupport::Concern

    @@is_activated = false

    included do
      @@encrypted_content_type = self.encrypted_content_type = Ripple::Encryption::JsonSerializer::REGISTER_KEY
    end

    module ClassMethods
      # @return [String] the content type to be used to indicate the
      #     proper encryption scheme. Defaults to 'application/x-json-encrypted'
      attr_accessor :encrypted_content_type
    end

    # Overrides the internal method to set the content-type to be
    # encrypted.
    def update_robject
      super
      robject.content_type = @@encrypted_content_type if Ripple::Encryption.activated?
    end

    def self.activate(path)
      primary_encryptor = nil
      [Ripple::Encryption::JsonSerializer, Ripple::Encryption::BinarySerializer].each do |serializer|
        encryptor = self.load_serializer(serializer, path)
        primary_encryptor if serializer == Ripple::Encryption::JsonSerializer
      end
      primary_encryptor
    end

    def self.activated?
      @@is_activated
    end

    private

    def self.load_serializer(serializer_class, path)
      begin
        config = YAML.load_file(path)[ENV['RACK_ENV']]
        encryptor = serializer_class.new(OpenSSL::Cipher.new(config['cipher']), path)
      rescue Exception => e
        handle_invalid_encryption_config(e)
      ensure
        @@is_activated = false
      end
      encryptor.key = config['key'] if config['key']
      encryptor.iv = config['iv'] if config['iv']
      Riak::Serializers[serializer_class::REGISTER_KEY] = encryptor
      @@is_activated = true
      encryptor
    end

  end
end

def handle_invalid_encryption_config(exception)
  raise Ripple::Encryption::ConfigError, <<eos

    The file "config/encryption.yml" is missing or incorrect. You will
    need to create this file and populate it with a valid cipher,
    initialization vector and secret key.

    An example is provided in "config/encryption.yml.example".

eos
end
