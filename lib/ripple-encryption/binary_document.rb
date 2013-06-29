module Ripple
  module Encryption
    # Implements an encapsulation in BINARY for encrypted Ripple documents.
    #
    # Example usage:
    #     Ripple::Encryption::BinaryDocument.new(config, @document).encrypt
    class BinaryDocument
      # Creates an object that is prepared to encrypt its contents.
      # @param [String] data object to store
      def initialize(config, data)
        config.generate_new_iv
        @config = config
        @data = data
        @encryptor = Ripple::Encryption::Encryptor.new @config.to_h
      end

      # Converts the data into the encrypted format
      def encrypt
        @config.generate_new_iv
        encrypted_data = @encryptor.encrypt @data
        {:version => Ripple::Encryption::VERSION, :iv => Base64.encode64(@config.to_h['iv']), :data => encrypted_data}
      end
    end
  end
end
