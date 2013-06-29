module Ripple
  module Encryption
    # Implements the {Riak::Serializer} API for the purpose of
    # encrypting/decrypting Ripple documents as JSON.
    #
    # Example usage:
    #     path = File.join(ROOT_DIR,'config','encryption.yml')
    #     
    #     ::Riak::Serializers['application/x-json-encrypted'] = Ripple::Encryption::JsonSerializer.new
    #     (
    #       OpenSSL::Cipher.new(config['cipher']), path
    #     )
    #
    #     class MyDocument
    #       include Ripple::Document
    #       include Ripple::Encryption
    #     end
    #
    # @see Encryption
    class JsonSerializer
      # @return [String] The Content-Type of the internal format,
      #      generally "application/json"
      attr_accessor :content_type

      # @return [OpenSSL::Cipher, OpenSSL::PKey::*] the cipher used to encrypt the object
      attr_accessor :cipher

      # Cipher-specific settings
      # @see OpenSSL::Cipher
      attr_accessor :key, :iv, :key_length, :padding

      # Creates a serializer using the provided cipher and internal
      # content type. Be sure to set the {#key}, {#iv}, {#key_length},
      # {#padding} as appropriate for the cipher before attempting
      # (de-)serialization.
      # @param [OpenSSL::Cipher] cipher the desired
      #     encryption/decryption algorithm
      # @param [String] path the File location of 'encryption.yml'
      #     private key file
      def initialize(cipher, path)
        @cipher, @content_type = cipher, 'application/x-json-encrypted'
        @config = Ripple::Encryption::Config.new(path)
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
        # this serializer now only supports the v2 (0.0.2 - 0.0.4) format
        return EncryptedJsonDocument.new(@config, object).decrypt
      end
    end
  end
end
