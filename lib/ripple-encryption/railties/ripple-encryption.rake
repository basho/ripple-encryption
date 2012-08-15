require 'pp'

namespace :riak do
end

def load_config
  file = Rails.root + "config/encryption.yml"
  raise Ripple::MissingConfiguration, file.to_s unless file.exist?
  YAML.load(ERB.new(file.read).result).with_indifferent_access
end
