# frozen_string_literal: true

require "time"

module Leafy
  module Converter
    class DatetimeConverter

      def dump(value)
        return if value.nil?

        target = value
        target = load(target) if target.is_a?(String)

        raise(ArgumentError, "is not a Time object") unless target.is_a?(Time)

        target.utc.iso8601
      end

      def load(value)
        return if value.nil?
        return value if value.is_a?(Time)
        Time.parse(value).utc
      end

    end
  end
end
