# frozen_string_literal: true

module Leafy
  module Converter
    class DoubleConverter
      def dump(value)
        return if value.nil?
        value.to_s
      end

      def load(value)
        return if value.nil?
        value.to_f
      end
    end
  end
end
