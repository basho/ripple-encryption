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

    should "write the current version of Ripple::Encrpytion" do
      document = TestDocument.new
      document.message = 'here is some new data'
      document.save
      raw_data = `curl -s http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{TestDocument.bucket_name}/keys/#{document.key}`
      assert_equal Ripple::Encryption::VERSION, (JSON.parse raw_data)['version']
    end
  end
end
