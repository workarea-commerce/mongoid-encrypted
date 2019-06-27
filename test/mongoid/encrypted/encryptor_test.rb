require 'test_helper'

module Mongoid
  module Encrypted
    class EncryptorTest < ActiveSupport::TestCase
      setup :set_encryption_key
      teardown :reset_encryption_key

      def test_encryption
        value = 'foo bar'

        message = Encryptor.encrypt('foo bar')
        assert_equal('foo bar', Encryptor.decrypt(message))

        old_key = ENV[config.env_key]
        set_encryption_key
        config.rotations << [old_key].pack("H*")

        refute_equal(message, Encryptor.encrypt('foo bar'))
        assert_equal('foo bar', Encryptor.decrypt(message))

        message = Encryptor.encrypt(123)
        assert_equal(123, Encryptor.decrypt(message))

        message = Encryptor.encrypt(["abc", 123])
        assert_equal(["abc", 123], Encryptor.decrypt(message))

        message = Encryptor.encrypt({ foo: 'bar', 'baz' => 123 })
        assert_equal({ foo: 'bar', 'baz' => 123 }, Encryptor.decrypt(message))
      end
    end
  end
end
