require 'openssl'

module Ripple
  module Encryption
    # Generic error class for Config
    class ConfigError < StandardError; end

    # Handles the configuration information for the Encryptor.
    #
    # Example usage:
    #     Ripple::Encryption::Config.defaults
    #     Ripple::Encryption::Config.new(:iv => "SOMEIV").to_h
    class Config
      # Initializes the config from our yml file.
      # @param [String] path to yml file
      def initialize(path)
        validate_path(path)
        @config = YAML.load_file(path)[ENV['RACK_ENV']]
      end

      # Return the options in the hash expected by Encryptor.
      def to_h
        @config
      end

      # Return either the default initialization vector, or create a new one.
      def activate
        @config['iv'] ||= OpenSSL::Random.random_bytes(16)
      end

      def validate_path(path)
        if !File.exists? path
          raise ConfigError, <<MISSINGFILE
The config file [usually "config/encryption.yml"] is missing or incorrect. You will
need to create this file and populate it with a valid cipher,
initialization vector and secret key.  An example is provided in 
"config/encryption.yml.example".
MISSINGFILE
        end
      end
    end
  end
end