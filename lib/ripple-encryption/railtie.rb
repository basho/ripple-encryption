require 'rails/railtie'

module Ripple
  module Encryption
    # Railtie for automatic initialization of the Ripple Encryption framework
    # during Rails initialization.
    class Railtie < Rails::Railtie
      rake_tasks do
        load "ripple-encryption/railties/ripple-encryption.rake"
      end

      initializer "ripple.encryption.configure_rails_initialization" do
        if File.exist?(Rails.root + "config/encryption.yml")
          Ripple::Encryption::Activation.new Rails.root.join('config', 'encryption.yml'), [Rails.env]
        end
      end
    end
  end
end
