# frozen_string_literal: true

module Leafy
  module Converter
    class BoolConverter
      def dump(value)
        target = value
        target = load(target) unless value.is_a?(TrueClass) || value.is_a?(FalseClass)

        target ? "1" : "0"
      end

      def load(value)
        return if value.nil?

        target = if value.respond_to?(:downcase)
                   begin
                     value.downcase
                   rescue StandardError
                     nil
                   end
                 else
                   value
                 end
        return true if ["1", "true", "t", 1, "yes", "y", true].include?(target)
        return false if ["0", "false", "f", 0, "no", "n", false].include?(target)

        raise(ArgumentError, "can't parse value to bool: #{value}")
      end
    end
  end
end
