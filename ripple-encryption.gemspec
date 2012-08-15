# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ripple-encryption/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Randy Secrist", "Casey Rosenthal"]
  gem.email         = ["rsecrist@basho.com", "casey@basho.com"]
  gem.description   = %q{Easily encrypt data at rest with minimal changes to existing ripple models.}
  gem.summary       = %q{A simple encryption library for objects stored in riak.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ripple-encryption"
  gem.require_paths = ["lib"]
  gem.version       = Ripple::Encryption::VERSION

  gem.add_dependency 'riak-client'
  gem.add_dependency 'ripple'

  # Test Dependencies
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'mini_shoulda'
end
