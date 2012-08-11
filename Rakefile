#!/usr/bin/env rake
require "bundler/gem_tasks"

require 'rake'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/test_*.rb']
  t.verbose = true
end

namespace :test do
  desc "Test everything"
  task :all => [:test]
end

task :default => :test

# Connect to Riak and test the client connection.

namespace :migrate do
  desc "Read in all unencrypted files, and save them to encrypted encoding."
  task :encrypt do
    Ripple::Encrytion::Migrate.new.convert(:encrypt)
  end

  desc "Read in all encrypted files, and save them unencrypted."
  task :decrypt do
    Ripple::Encrytion::Migrate.new.convert(:decrypt)
  end
end
