module Mongoid
  module Encrypted
    class Encryptor
      class MissingKeyError < RuntimeError
        def initialize(key_path:, env_key:)
          super \
            "Missing encryption key to decrypt file with. " +
            "Ask your team for your master key and write it to #{key_path} or put it in the ENV['#{env_key}']."
        end
      end

      class << self
        def encrypt(value)
          instance.encrypt_and_sign(value)
        end

        def decrypt(value)
          crypt = instance

          if config.rotations.present?
            config.rotations.each { |r| crypt.rotate *Array.wrap(r) }
          end

          crypt.decrypt_and_verify(value)
        end

        private

        def instance
          ActiveSupport::MessageEncryptor.new(
            [ key ].pack("H*"),
            cipher: config.cipher
          )
        end

        def key
          read_env_key || read_key_file || handle_missing_key
        end

        def read_env_key
          ENV[config.env_key]
        end

        def read_key_file
          Rails.root.join(config.key_path).binread.strip rescue nil
        end

        def handle_missing_key
          raise(
            MissingKeyError,
            key_path: config.key_path,
            env_key: config.env_key
          )
        end

        def config
          Encrypted.configuration
        end
      end
    end
  end
end
