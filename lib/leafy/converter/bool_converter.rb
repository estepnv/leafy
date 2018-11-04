# frozen_string_literal: true

module Leafy
  module Converter
    class BoolConverter
      def dump(value)
        target = value.dup
        target = load(target) unless value.is_a?(TrueClass) || value.is_a?(FalseClass)

        target ? "1" : "0"
      end

      def load(value)
        return if value.nil?

        case value.respond_to?(:downcase) ? value&.downcase : value
        when "1", "true", "t", 1, "yes", "y"
          true
        when "0", "false", "f", 0, "no", "n"
          false
        else
          raise(ArgumentError, "can't parse value to bool: #{value}")
        end
      end
    end
  end
end
