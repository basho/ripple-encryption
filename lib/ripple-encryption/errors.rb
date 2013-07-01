module Ripple
  module Encryption
  	# reserved for general config lookup errors
  	class ConfigError < StandardError; end

  	# reserved for specific encryptor (openssl) config related errors
  	class EncryptorConfigError < StandardError; end

  	# reserved for issues decrypting & deserializing JSON
  	class EncryptedJsonDocumentError < StandardError; end
  end
end