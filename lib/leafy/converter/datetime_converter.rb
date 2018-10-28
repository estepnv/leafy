# frozen_string_literal: true

require "time"

module Leafy
  module Converter
    class DatetimeConverter
      
      def dump(value)
        return if value.nil?

        target = value.dup
        target = load(target) if value.is_a?(String)

        unless value.is_a?(Time)
          raise(ArgumentError, "is not a Time object")
        end

        value.iso8601
      end

      def load(value)
        return if value.nil?
        return value if value.is_a?(Time)
        Time.parse(value)
      end

    end
  end
end
