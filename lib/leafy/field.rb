# frozen_string_literal: true
require 'securerandom'

module Leafy
  class Field
    attr_accessor :id, :name, :type, :metadata

    def initialize(attributes = {})
      raise ArgumentError, "attributes is not a Hash" unless attributes.is_a?(Hash)
      attributes = Leafy::Utils.symbolize_keys(attributes)

      self.name = attributes[:name]
      self.type = attributes[:type]
      self.id = attributes.fetch(:id) { [name.downcase.strip.tr(" ", "-"), SecureRandom.uuid].join("-") }
      self.metadata = attributes.fetch(:metadata, {})
    end

    def serializable_hash
      {
        name: name,
        type: type,
        id: id,
        metadata: metadata
      }
    end
  end
end
