require 'json'

module Leafy
  class Configuration
    attr_accessor :coder

    def initialize
      @coder = Leafy::Coder::Default
    end

    def coder=(value)
      if value.respond_to?(:dump) && value.respond_to?(:load)
        @coder = value
      end

      raise ArgumentError, "coder must implement #dump and #load"
    end
  end
end
