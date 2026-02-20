# frozen_string_literal: true

module Leafy
  module Coder
    class Mock
      def dump(data)
        data
      end

      def load(data)
        data
      end
    end
  end
end
