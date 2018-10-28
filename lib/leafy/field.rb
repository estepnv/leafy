# frozen_string_literal: true

module Leafy
  class Field
    attr_accessor :id, :name, :type, :placeholder, :default, :required, :readonly, :hidden, :order

    def initialize(attributes = {})
      attributes = attributes.dup.to_a.map { |pair| [pair[0].to_sym, pair[1]]}.to_h

      self.name = attributes.fetch(:name)
      self.type = attributes.fetch(:type).to_sym
      self.id = attributes.fetch(:id) { "#{name.downcase.strip.tr(" ", "_")}_#{Time.now.to_i + rand(1_000_000)}" }
      self.placeholder = attributes[:placeholder]
      self.default = attributes[:default]
      self.required = attributes.fetch(:required) { false }
      self.readonly = attributes.fetch(:readonly) { false }
      self.hidden = attributes.fetch(:hidden) { false }
      self.order = attributes.fetch(:order) { 0 }
    end

    def serializable_hash
      {
        name: name,
        type: type,
        id: id,
        placeholder: placeholder,
        default: default,
        required: required,
        readonly: readonly,
        hidden: hidden,
        order: order
      }
    end
  end
end
