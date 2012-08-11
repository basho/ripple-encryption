require 'helper'

class TestRipple < Test::Unit::TestCase
  context "TestDocument" do
    should "read the ripple document" do
      assert doc = TestDocument.find('some_other_data')
      assert_equal 'this is secret data', doc.message
    end

    should "write the ripple document" do
      document = TestDocument.new
      document.message = 'here is some new data'
      document.save
      same_document = TestDocument.find(document.key)
      assert_equal document.message, same_document.message
    end

    should "write the ripple document raw confirmation" do
      document = TestDocument.new
      document.message = 'here is some new data'
      document.save
      expected_doc_data = '{"version":"0.1.0","iv":"ABYLnUHWE/fIwE2gKYC6hg==\n","data":"VpQTfX23xKdMK4Kprp/xgwDh4UFFSYC8q4OeOhK2zPn0l5huFO+vsoBrq8pT\nd5Z3EdgPx3k8VpL0QNH1FM6m4g==\n"}'
      raw_data = `curl -s -XGET http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{TestDocument.bucket_name}/keys/#{document.key}`
      assert_equal expected_doc_data, raw_data
    end
  end
end
