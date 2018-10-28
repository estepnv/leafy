# frozen_string_literal: true

module Leafy
  class FieldValueCollection
    include ::Enumerable

    def each
      if block_given?
        @Leafy_field_values.each { |i| yield i }
      else
        @Leafy_field_values.each
      end
    end

    def [](index)
      to_a[index]
    end

    def size
      count
    end

    def initialize(leafy_fields, values = {})
      @leafy_fields = leafy_fields
      @Leafy_field_values = leafy_fields.map do |custom_field|
        Leafy::FieldValue.new(
          id: custom_field.id,
          name: custom_field.name,
          raw: values[custom_field.id],
          type: custom_field.type,
          default: custom_field.default
        )
      end
    end

    def values
      inject({}) do |acc, field_value|
        acc[field_value.id] = field_value.value
        acc
      end
    end
    
    def values=(attributes = {})
      attributes = attributes.dup.to_a.map { |pair| [pair[0].to_s, pair[1]]}.to_h

      @Leafy_field_values.each do |field_value|
        field_value.value = attributes[field_value.id]
      end
    end

    def self.dump(field_values_collection)
      JSON.dump(field_values_collection.map { |field_value| [field_value.id, field_value.raw] }.to_h)
    end

    def self.load(leafy_fields, data)
      Leafy::FieldValueCollection.new(leafy_fields, JSON.load(data))
    end

  end
end
