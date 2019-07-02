module Mongoid
  module Fields
    class Encrypted < Standard
      def demongoize(object)
        if object
          type.demongoize(Mongoid::Encrypted::Encryptor.decrypt(object))
        end
      end

      def encrypted?
        true
      end

      def mongoize(object)
        Mongoid::Encrypted::Encryptor.encrypt(object)
      end
    end
  end

  Fields.option(:encrypted) { |_model, _field, value| value }
end
