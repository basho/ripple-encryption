module Ripple
  module Encryption
    # Implements an encapsulation in JSON for encrypted Ripple documents.
    #
    # Example usage:
    #     Ripple::Encryption::JsonDocument.new(@document).encrypt
    class JsonDocument
      # Creates an object that is prepared to encrypt its contents.
      # @param [String] data object to store
      def initialize(config, data)
        config.activate
        @config = config.to_h
        @data = JSON.dump(data)
        @encryptor = Ripple::Encryption::Encryptor.new @config
      end

      # Converts the data into the encrypted format
      def encrypt
        encrypted_data = @encryptor.encrypt @data
        JSON.dump({:version => Ripple::Encryption::VERSION, :iv => Base64.encode64(@config['iv']), :data => Base64.encode64(encrypted_data)})
      end
    end
  end
end
