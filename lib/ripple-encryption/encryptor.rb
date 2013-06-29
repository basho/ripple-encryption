module Ripple
  module Encryption
    # Implements a simple object that can either encrypt or decrypt arbitrary data.
    #
    # Example usage:
    #     encryptor = Ripple::Encryption::Encryptor.new Ripple::Encryption::Config.defaults
    #     encryptor.encrypt stuff
    #     encryptor.decrypt stuff
    class Encryptor
      # Creates an Encryptor that is prepared to encrypt/decrypt a blob.
      # @param [Hash] config the key/cipher/iv needed to initialize OpenSSL
      def initialize(config)
        # ensure that we have the required configuration keys
        %w(cipher key iv).each do |option|
          raise(Ripple::Encryption::EncryptorConfigError, "Missing configuration option '#{option}'.") if config[option].nil?
        end
        @config = config
        @cipher = OpenSSL::Cipher.new(@config['cipher'])
      end

      # Encrypt stuff.
      # @param [Object] blob the data to encrypt
      def encrypt(blob)
        initialize_cipher_for :encrypt
        "#{@cipher.update blob}#{@cipher.final}"
      end

      # Decrypt stuff.
      # @param [Object] blob the encrypted data to decrypt
      def decrypt(blob)
        initialize_cipher_for :decrypt
        "#{@cipher.update blob}#{@cipher.final}"
      end

      private
      # This sets the mode so OpenSSL knows to encrypt or decrypt, etc.
      # @param [Symbol] mode either :encrypt or :decrypt
      def initialize_cipher_for(mode)
        @cipher.send mode
        @cipher.key = @config['key']
        @cipher.iv  = @config['iv']
      end
    end
  end
end
