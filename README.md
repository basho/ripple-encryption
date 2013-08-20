# Ripple::Encryption [![Build Status](https://travis-ci.org/basho/ripple-encryption.png)](https://travis-ci.org/basho/ripple-encryption)

The ripple-encryption gem provides encryption and decryption for Ripple documents.  This gem's primary dependencies are [riak-ruby](https://github.com/basho/riak-ruby-client) and [ripple](https://github.com/basho/ripple).


## Installation

Add this line to your application's Gemfile:

    gem 'ripple-encryption'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ripple-encryption

## Overview

You call the activation, which initializes a global serializer within
Ripple.  Any object that gets saved with content-type 'application/x-json-encrypted'
then goes through the Encryption::Serializer, which loads or unloads the
data from Riak through the JsonDocument and EncryptedJsonDocument,
respectively.  Both of these have a dependency on Encryption::Encrypter,
which makes the actual calls to OpenSSL.

JsonDocument stores the encrypted data wrapped in JSON encapsulation so
that you can still introspect the Riak object and see which version of
this gem was used to encrypt it.  As of version 0.0.4, this is now the only
supported serialization format for JSON data.

There is also a Rake file to convert between encrypted and decrypted
JSON objects.

## Usage

Include the gem in your Gemfile.  Activate it somewhere in your
application initialization by pointing it to your encryption config file
like so:

    Ripple::Encryption.activate PATH_TO_CONFIG_FILE

Then include the Ripple::Encryption module in your document class:

    class SomeDocument
      include Ripple::Document
      include Ripple::Encryption
      property :message, String
    end

These documents will now be stored encrypted.

## Running the Tests

Adjust the 'test/fixtures/ripple.yml' to point to a test riak database.

    bundle exec rake

## Compatibility Matrix

This gem stores serialized encryption objects into Riak.  The serialization
format is versioned; and where possible incrementally transitioned from one
version to another.  Currently; only the ```JsonSerializer``` supports this
type of incremental transition with the support matrix below.

| version  | First | Last    |
| -------- | ----- | ------- |
| v1       | 0.0.1 | 0.0.3   |
| v2       | 0.0.2 | current |

The ```BinarySerializer``` does not support incremental format transition but
does make the version and iv available for external code to support this.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
