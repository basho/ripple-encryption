require 'helper'

class TestUnencryptedDocument < Test::Unit::TestCase
  context "unencrypted GenericModel" do
    should "read unencrypted document type" do
      assert (doc = TestDocument.find('some_data')), "Could not find fixture."
      assert_equal 'this is unencrypted data', doc.message
    end

    should "write unencrypted document type when content-type is plain" do
      document = TestDocument.new
      document.message = 'here is some new data'
      document.robject.content_type = 'application/json'
      document.save
      expected_doc_data = '{"message":"here is some new data","_type":"TestDocument"}'
      raw_data = `curl -s -XGET http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{TestDocument.bucket_name}/keys/#{document.key}`
      assert_equal expected_doc_data, raw_data
    end
  end
end
