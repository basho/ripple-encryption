require 'helper'

class TestRipple < MiniTest::Spec
  context "TestDocument" do
    should "write the ripple document" do
      document = TestDocument.new
      document.message = 'here is some new data'
      document.save
      same_document = TestDocument.find(document.key)
      assert_equal document.message, same_document.message

      # read the document back out
      read_doc = TestDocument.find(document.key)
      assert_equal 'here is some new data', read_doc.message
    end

    should "write the ripple document raw confirmation" do
      document = TestDocument.new
      document.message = 'here is some new data'
      document.save
      expected_data = 'VpQTfX23xKdMK4Kprp/xgwDh4UFFSYC8q4OeOhK2zPn0l5huFO+vsoBrq8pT\nd5Z3EdgPx3k8VpL0QNH1FM6m4g==\n'
      expected_doc_data = "{\"version\":\"#{Ripple::Encryption::VERSION}\",\"iv\":\"ABYLnUHWE/fIwE2gKYC6hg==\\n\",\"data\":\"#{expected_data}\"}"
      raw_data = `curl -s http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{TestDocument.bucket_name}/keys/#{document.key}`
      assert_equal expected_doc_data, raw_data
    end
  end
end
