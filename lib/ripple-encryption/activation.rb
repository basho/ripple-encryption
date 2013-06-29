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
        @@encrypted_content_type = self.encrypted_content_type = 'application/x-json-encrypted'
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
        if @@is_activated
          robject.content_type = @@encrypted_content_type
        end
      end

      def self.activate(path)
        encryptor = nil
        unless Riak::Serializers['application/x-json-encrypted']
          begin
            config = YAML.load_file(path)[ENV['RACK_ENV']]
            encryptor = Ripple::Encryption::JsonSerializer.new(OpenSSL::Cipher.new(config['cipher']), path)
          rescue Exception => e
            handle_invalid_encryption_config(e.message, e.backtrace)
          end
          encryptor.key = config['key'] if config['key']
          encryptor.iv = config['iv'] if config['iv']
          Riak::Serializers['application/x-json-encrypted'] = encryptor
          @@is_activated = true
        end
        encryptor
      end

      def self.activated
        @@is_activated
      end

  end
end

def handle_invalid_encryption_config(msg, trace)
  puts <<eos

    The file "config/encryption.yml" is missing or incorrect. You will
    need to create this file and populate it with a valid cipher,
    initialization vector and secret key.

    An example is provided in "config/encryption.yml.example".
eos

  puts "Error Message: " + msg
  puts "Error Trace:"
  trace.each do |line|
    puts line
  end

  exit 1
end
