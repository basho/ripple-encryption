module Ripple
  module Encryption
    # Implements the {Riak::Serializer} API for the purpose of
    # encrypting/decrypting Ripple documents.
    #
    # Example usage:
    #     ::Riak::Serializers['application/x-json-encrypted'] = Ripple::Encryption::Serializer.new(OpenSSL::Cipher.new("AES-256"))
    #     class MyDocument
    #       include Ripple::Document
    #       include Riak::Encryption
    #     end
    #
    # @see Encryption
    class Serializer
      # @param [Ripple::Encryption::Config]
      def initialize(config)
        @config = config
      end

      # Serializes and encrypts the Ruby object using the assigned
      # cipher and Content-Type.
      # @param [Object] object the Ruby object to serialize/encrypt
      # @return [String] the serialized, encrypted form of the object
      def dump(object)
        JsonDocument.new(@config, object).encrypt
      end

      # Decrypts and deserializes the blob using the assigned cipher
      # and Content-Type.
      # @param [String] blob the original content from Riak
      # @return [Object] the decrypted and deserialized object
      def load(object)
        EncryptedJsonDocument.new(@config, object).decrypt
      end
    end
  end
end
