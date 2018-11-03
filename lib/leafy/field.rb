# frozen_string_literal: true

module Leafy
  class Field
    attr_accessor :id, :name, :type, :metadata

    def initialize(attributes = {})
      raise ArgumentError, "attributes is not a Hash" unless attributes.is_a?(Hash)
      attributes = Leafy::Utils.symbolize_keys(attributes)

      self.name = attributes.fetch(:name)
      self.type = attributes.fetch(:type).to_sym
      self.id = attributes.fetch(:id) { "#{name.downcase.strip.tr(" ", "_")}_#{Time.now.to_i + rand(1_000_000)}" }
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
