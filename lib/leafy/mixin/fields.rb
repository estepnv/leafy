# frozen_string_literal: true

module Leafy
  module Mixin
    module Fields

      def self.[](orm = :poro)
        case orm
        when :poro
          include Poro::InstanceMethods
          extend Poro::ClassMethods
        else
          raise(RuntimeError, "Leafy: unsupported fields storage: #{orm}")
        end
      end

    end
  end
end
