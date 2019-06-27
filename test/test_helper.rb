$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mongoid/encrypted"
require "minitest/autorun"

ENV['MONGOID_ENV'] ||= 'test'
Mongoid.load!("#{File.dirname(__FILE__)}/mongoid.yml")

# Filter out Minitest backtrace while allowing backtrace from other libraries
# to be shown.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

module EncryptedTest
  extend ActiveSupport::Concern

  included do
    setup :capture_config_state
    teardown :reset_environment
  end

  def capture_config_state
    @original_config = config.dup
  end

  def reset_environment
    ENV[config.env_key] = nil
    Mongoid::Encrypted.configuration = @original_config
  end

  def set_encryption_key(key: generate_key)
    @original_key ||= ENV[config.env_key]
    ENV[config.env_key] = key
  end

  def reset_encryption_key
    ENV[config.env_key] = @original_key
  end

  def generate_key
    SecureRandom.hex(ActiveSupport::MessageEncryptor.key_len(config.cipher))
  end

  def config
    Mongoid::Encrypted.configuration
  end
end

ActiveSupport::TestCase.include(EncryptedTest)
