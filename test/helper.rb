$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'minitest/autorun'
require 'mini_shoulda'

require 'ripple-encryption'

ENV['RACK_ENV']   = 'test'
ENV['RIPPLE']     = File.expand_path(File.join('..','fixtures','ripple.yml'),__FILE__)
ENV['ENCRYPTION'] = File.expand_path(File.join('..','fixtures','encryption.yml'),__FILE__)

# connect to a local Riak test node
begin
  Ripple.load_configuration ENV['RIPPLE'], ['test']
  riak_config = Hash[YAML.load_file(ENV['RIPPLE'])['test'].map{|k,v| [k.to_sym, v]}]
  client = Riak::Client.new(:nodes => [riak_config])
  bucket = client.bucket("#{riak_config[:namespace].to_s}test") 
  object = bucket.get_or_new("test") 
rescue RuntimeError => e
  raise e
end

# activate the library
Ripple::Encryption::Activation.new ENV['ENCRYPTION']

class TestDocument
  include Ripple::Document
  include Ripple::Encryption
  property :message, String

  def self.bucket_name
    "#{Ripple.config[:namespace]}#{super}"
  end
end

# load Riak fixtures the raw way
FileList[File.expand_path(File.join('..','fixtures','*'),__FILE__)].each do |f|
  if Dir.exists? f
    fixture_type = File.basename(f)
    begin
      klass = fixture_type.classify.constantize
    rescue NameError
      raise NameError, "Is a Ripple Document of type '#{fixture_type.classify}' defined for that fixture file?"
    end
    # unencrypted jsons
    FileList[File.join(f,'*.unencrypted.riak')].each do |r|
      key = File.basename(r,'.unencrypted.riak')
      `curl -s -H 'content-type: application/json' -XPUT http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{Ripple.config[:namespace]}#{fixture_type.pluralize}/keys/#{key} --data-binary @#{r}`
    end
    # encrypted jsons
    FileList[File.join(f,'*.encrypted.riak')].each do |r|
      key = File.basename(r,'.encrypted.riak')
      `curl -s -H 'content-type: application/x-json-encrypted' -XPUT http://#{Ripple.config[:host]}:#{Ripple.config[:http_port]}/buckets/#{Ripple.config[:namespace]}#{fixture_type.pluralize}/keys/#{key} --data-binary @#{r}`
    end
  end
end
