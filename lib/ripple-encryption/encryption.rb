module Ripple
  # When mixed into a Ripple::Document class, this will encrypt the
  # serialized form before it is stored in Riak.  You must register
  # a serializer that will perform the encryption.
  # @see Serializer
  module Encryption
    # Overrides the internal method to set the content-type to be
    # encrypted.
    def robject
      @robject ||= Riak::RObject.new(self.class.bucket, key).tap do |obj|
        obj.content_type = 'application/x-json-encrypted'
      end
    end
    def update_robject
      robject.key = key if robject.key != key
      robject.content_type ||= 'application/x-json-encrypted'
      robject.data = attributes_for_persistence
    end
  end
end
