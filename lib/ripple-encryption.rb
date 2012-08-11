require 'openssl'
require 'ripple'

module Ripple
  module Encryption
  end
end

# Include all of the support files.
FileList[File.expand_path(File.join('..','ripple-encryption','*.rb'),__FILE__)].each{|f| require f}
