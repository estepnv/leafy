# frozen_string_literal: true

module Leafy
  module Converter
    class IntegerConverter
      def dump(value)
        value.nil? ? nil : value.to_s
      end

      def load(value)
        value.nil? ? nil : value.to_i
      end
    end
  end
end
