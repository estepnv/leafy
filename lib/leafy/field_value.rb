# frozen_string_literal: true

module Leafy
  class FieldValue
    attr_accessor :id, :name, :type, :raw, :converter

    def initialize(attributes)
      attributes = attributes.transform_keys(&:to_sym)

      self.id = attributes.fetch(:id)
      self.name = attributes.fetch(:name)
      self.type = attributes.fetch(:type)
      self.converter = attributes.fetch(:converter) { Leafy.converters.fetch(type.to_sym) { raise(RuntimeError, "unregistered converter #{type}") } }
      self.raw = attributes.fetch(:raw)
    end

    def value
      converter.load(raw)
    end

    def value=(val)
      self.raw = converter.dump(converter.load(val))
    end
  end
end
