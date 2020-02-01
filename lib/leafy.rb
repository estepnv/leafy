# frozen_string_literal: true

require "leafy/version"
require "leafy/utils"
require "leafy/field"
require "leafy/schema"
require "leafy/field_value"
require "leafy/field_value_collection"
Dir[File.expand_path("../leafy/converter/**/*.rb", __FILE__)].each { |f| require f }
require "leafy/mixin/schema"
require "leafy/mixin/fields"
require "leafy/coder/default"
require "leafy/coder/mock"
require "leafy/configuration"


# module definition
module Leafy

  def self.configure
    yield configuration if block_given?
  end

  def self.configuration
    @config ||= Leafy::Configuration.new
  end

  def self.register_converter(name, converter)
    raise(ArgumentError, "converter is not provided") if converter.nil?

    if !converter.respond_to?(:load) || !converter.respond_to?(:dump)
      raise(ArgumentError, "converter must respond to #dump and #load")
    end

    converters[name] = converter
  end

  def self.converters
    @converters ||= {}
  end
end

Leafy.register_converter(:dummy, Leafy::Converter::DummyConverter.new)
Leafy.register_converter(:string, Leafy::Converter::StringConverter.new)
Leafy.register_converter(:integer, Leafy::Converter::IntegerConverter.new)
Leafy.register_converter(:double, Leafy::Converter::DoubleConverter.new)
Leafy.register_converter(:datetime, Leafy::Converter::DatetimeConverter.new)
Leafy.register_converter(:bool, Leafy::Converter::BoolConverter.new)
Leafy.register_converter(:date, Leafy::Converter::DateConverter.new)
