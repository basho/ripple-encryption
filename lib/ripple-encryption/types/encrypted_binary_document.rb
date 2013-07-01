module Ripple
  module Encryption
    # Interprets a encapsulation in BINARY for encrypted Ripple documents.
    #
    # Example usage:
    #     Ripple::Encryption::EncryptedBinaryDocument.new(@document).encrypt
    class EncryptedBinaryDocument
      # Creates an object that is prepared to decrypt its contents.
      # @param [Hash] data that was stored in Riak, has keys (:version, :iv, :data)
      def initialize(config, data)
        @config = config.to_h.clone
        @data = data
        raise(EncryptedJsonDocumentError, "Missing 'iv' for decryption") unless @data[:iv]
        iv = Base64.decode64 @data[:iv]
        @config.merge!('iv' => iv)

        @decryptor = Ripple::Encryption::Encryptor.new @config
      end

      # Returns the original data from the stored encrypted format
      def decrypt
        @decryptor.decrypt @data[:data]
      end
    end
  end
end
