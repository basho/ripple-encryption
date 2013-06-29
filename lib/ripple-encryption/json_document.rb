module Ripple
  module Encryption
    # Implements an encapsulation in JSON for encrypted Ripple documents.
    #
    # Example usage:
    #     Ripple::Encryption::JsonDocument.new(config, @document).encrypt
    class JsonDocument
      # Creates an object that is prepared to encrypt its contents.
      # @param [String] data object to store
      def initialize(config, data)
        config.generate_new_iv
        @config = config
        @data = JSON.dump(data)
        @encryptor = Ripple::Encryption::Encryptor.new @config.to_h
      end

      # Converts the data into the encrypted format
      def encrypt
        @config.generate_new_iv
        encrypted_data = @encryptor.encrypt @data
        JSON.dump({:version => Ripple::Encryption::VERSION, :iv => Base64.encode64(@config.to_h['iv']), :data => Base64.encode64(encrypted_data)})
      end
    end
  end
end
