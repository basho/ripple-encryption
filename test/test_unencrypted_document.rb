require 'helper'

class TestMigrationV1ToV2 < MiniTest::Spec
  context "unencrypted GenericModel" do
    setup do
    end

    should "read unencrypted document type" do
      assert v0 = TestDocument.find('v0_doc')
      assert_equal 'this is unencrypted data', v0.message
    end

    should "write unencrypted document type when content-type is plain" do
      document = TestDocument.new
      document.message = 'here is some new data'
      Ripple::Encryption::Encryption.class_variable_set(:@@is_activated, false)
      document.robject.content_type = 'application/json'
      document.save
      expected_v2_data = '{"message":"here is some new data","_type":"TestDocument"}'
      raw_data = `curl -s -XGET http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{TestDocument.bucket_name}/keys/#{document.key}`
      assert_equal expected_v2_data, raw_data
    end
  end
end
