require 'test_helper'

module Mongoid
  class EncryptedTest < ActiveSupport::TestCase
    setup :set_encryption_key
    teardown :reset_encryption_key

    class FooModel
      include Mongoid::Document
      include Mongoid::Encrypted

      field :password, type: String, encrypted: true
      field :passcode, type: Integer, encrypted: true
      field :secrets, type: Hash, encrypted: true
    end

    def test_encryption
      model = FooModel.new(
        password: 'test password',
        passcode: 1234,
        secrets: { foo: 'bar', baz: 12 }
      )

      assert_equal(Fields::Encrypted, model.fields['password'].class)
      assert(FooModel.encrypted_fields.has_key?('password'))

      assert_equal('test password', model.password)
      assert_equal(1234, model.passcode)
      assert_equal({ foo: 'bar', baz: 12 }, model.secrets)

      refute_equal('test password', model.attributes['password'])
      refute_equal(1234, model.attributes['passcode'])
      refute_equal({ foo: 'bar', baz: 12 }, model.attributes['secrets'])

      model.save
      model.reload

      assert_equal('test password', model.password)
      assert_equal(1234, model.passcode)
      assert_equal({ foo: 'bar', baz: 12 }, model.secrets)

      refute_equal('test password', model.attributes['password'])
      refute_equal(1234, model.attributes['passcode'])
      refute_equal({ foo: 'bar', baz: 12 }, model.attributes['secrets'])

      assert_equal(
        'test password',
        Encrypted::Encryptor.decrypt(model.attributes['password'])
      )
      assert_equal(
        1234,
        Encrypted::Encryptor.decrypt(model.attributes['passcode'])
      )
      assert_equal(
        { foo: 'bar', baz: 12 },
        Encrypted::Encryptor.decrypt(model.attributes['secrets'])
      )

      model.attributes = {
        password: 'test password',
        passcode: 1234,
        secrets: { foo: 'bar', baz: 12 }
      }

      assert(model.changes.blank?)
      refute(model.password_changed?)
      refute(model.passcode_changed?)
      refute(model.secrets_changed?)

      model.attributes =  { password: 'changed password' }
      assert(model.password_changed?)
    end
  end
end
