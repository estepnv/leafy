# frozen_string_literal: true

module Leafy
  module Mixin
    module Fields

      def self.[](orm = :poro)
        self.extend DataAccessor::ClassMethods
        self.include DataAccessor::InstanceMethods

        case orm
        when :poro
          self.extend Poro::ClassMethods
          self.include Poro::InstanceMethods
        else
          raise(RuntimeError, "Leafy: unsupported fields storage: #{orm}")
        end

        self
      end

    end
  end
end
