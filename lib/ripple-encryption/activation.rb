module Ripple
  module Encryption
    class Activation

      def initialize(path)
        config = Ripple::Encryption::Config.new path
        # short-circuit encryption via the config file if desired
        if !Riak::Serializers['application/x-json-encrypted'] && (config.to_h['encryption'] != false)
          Riak::Serializers['application/x-json-encrypted'] = Ripple::Encryption::Serializer.new config
        end
        @@is_activated = true
      end

      def self.activated?
        @@is_activated
      end
    end
  end
end
