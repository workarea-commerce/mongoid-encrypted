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

    included do
      class_attribute :encrypted_fields
      self.encrypted_fields = {}

      after_find :_track_encrypted_fields
    end

    def self.configure
      yield configuration
    end

    private

    def attribute_will_change!(attr)
      field = fields[attr]
      return if field.options[:encrypted] &&
        _decrypted_values_match?(
          field,
          instance_variable_get(:"@_#{attr}_persisted_value"),
          read_attribute(attr)
        )

      super
    end

    def _track_encrypted_fields
      encrypted_fields.each do |name, _|
        instance_variable_set(:"@_#{name}_persisted_value", read_attribute(name))
      end
    end

    def _decrypted_values_match?(field, *values)
      values.map { |v| field.demongoize(v) }.uniq.size == 1
    end

    module ClassMethods
      protected

      def field_for(name, options)
        return super unless options[:encrypted]

        opts = options.merge(klass: self)
        type_mapping = Fields::TYPE_MAPPINGS[options[:type]]
        opts[:type] = type_mapping || unmapped_type(options)
        Fields::Encrypted.new(name, opts).tap do |field|
          encrypted_fields[name] = field
        end
      end
    end
  end
end
