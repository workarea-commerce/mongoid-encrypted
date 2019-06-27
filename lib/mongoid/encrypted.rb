require "mongoid/encrypted/version"
require 'mongoid'
require 'active_support'

require 'mongoid/fields/encrypted'
require 'mongoid/encrypted/encryptor'

module Mongoid
  module Encrypted
    extend ActiveSupport::Concern

    cattr_accessor :configuration
    self.configuration =
      ActiveSupport::Configurable::Configuration.new(
        cipher: 'aes-128-gcm',
        env_key: 'RAILS_MASTER_KEY',
        key_path: 'config/master.key',
        rotations: []
      )

    def self.configure
      yield configuration
    end

    module ClassMethods
      protected

      def field_for(name, options)
        return super unless options[:encrypted]

        opts = options.merge(klass: self)
        type_mapping = Fields::TYPE_MAPPINGS[options[:type]]
        opts[:type] = type_mapping || unmapped_type(options)
        Fields::Encrypted.new(name, opts)
      end
    end
  end
end
