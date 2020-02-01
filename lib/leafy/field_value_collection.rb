# frozen_string_literal: true

module Leafy
  class FieldValueCollection
    include ::Enumerable

    def initialize(leafy_fields, field_values: {}, ar_json: false)
      @leafy_fields = leafy_fields
      @coder = ar_json ? Leafy::Coder::Mock.new : Leafy.configuration.coder
      self.leafy_field_values = field_values
    end

    def leafy_field_values=(data)
      @leafy_field_values = @leafy_fields.map do |custom_field|
        Leafy::FieldValue.new(
          id: custom_field.id,
          name: custom_field.name,
          raw: data[custom_field.id],
          type: custom_field.type
        )
      end
    end

    def each
      if block_given?
        @leafy_field_values.each { |i| yield i }
      else
        @leafy_field_values.each
      end
    end

    def [](index)
      to_a[index]
    end

    def size
      count
    end

    def values
      inject({}) do |acc, field_value|
        acc[field_value.id] = field_value.value
        acc
      end
    end

    def values=(attributes = {})
      _attributes = {}

      attributes.each { |key, value| _attributes[key.to_s] = value }

      @leafy_field_values.each do |field_value|
        field_value.value = _attributes[field_value.id]
      end
    end

    def dump
      data = {}
      each { |field_value| data[field_value.id] = field_value.raw }
      @coder.dump(data)
    end

    def load(data)
      self.leafy_field_values = @coder.load(data)
    end

  end
end
