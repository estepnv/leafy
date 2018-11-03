module Leafy
  module Utils
    def self.symbolize_keys(hash)
      hash.dup.to_a.map do |pair|
        key, value = pair
        [key.to_sym, value.is_a?(Hash) ? Leafy::Utils.symbolize_keys(value) : value]
      end.to_h
    end

    def self.stringify_keys(hash)
      hash.dup.to_a.map do |pair|
        key, value = pair
        [key.to_s, value.is_a?(Hash) ? Leafy::Utils.stringify_keys(value) : value]
      end.to_h
    end
  end
end