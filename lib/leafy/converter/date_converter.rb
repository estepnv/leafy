# frozen_string_literal: true

require "date"

module Leafy
  module Converter
    class DateConverter

      def dump(value)
        return if value.nil?

        target = value
        target = load(target) if target.is_a?(String)
        target = target.to_date if target.is_a?(Time)

        unless target.is_a?(Date)
          raise(ArgumentError, "is not a Date object")
        end

        target.iso8601
      end

      def load(value)
        return if value.nil?
        return value if value.is_a?(Date)
        Date.parse(value)
      end

    end
  end
end
