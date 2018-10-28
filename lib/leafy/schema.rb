# frozen_string_literal: true
require "json"

module Leafy
  class Schema
    include ::Enumerable

    def each
      if block_given?
        @fields.each { |i| yield i }
      else
        @fields.each
      end
    end

    def initialize(fields = [])
      @fields = fields.map { |field| Leafy::Field.new(field) }
    end

    def ids
      @fields.map(&:id)
    end

    def [](identifier)
      @fields.find { |f| f.id == identifier }
    end

    def push(field)
      raise(ArgumentError, "is not a field") unless field.is_a?(Leafy::Field)
      @fields << field
    end

    def serializable_hash
      @fields.map(&:serializable_hash)
    end

    def self.dump(schema)
      JSON.dump(schema.serializable_hash)
    end

    def self.load(data)
      Schema.new(JSON.parse(data))
    end

    alias :<< :push
  end
end
