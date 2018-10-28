# frozen_string_literal: true

module Leafy
  module Converter
    class DummyConverter
      def dump(value)
        value
      end

      def load(value)
        value
      end
    end
  end
end
