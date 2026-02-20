# frozen_string_literal: true

require "leafy/version"
require "leafy/utils"
require "leafy/field"
require "leafy/schema"
require "leafy/field_value"
require "leafy/field_value_collection"
Dir[File.join(__dir__, "leafy/converter/**/*.rb")].each { |f| require f }
require "leafy/mixin/schema"
require "leafy/mixin/fields"
require "leafy/coder/default"
require "leafy/coder/mock"
require "leafy/configuration"


# module definition
module Leafy
  @config_mutex = Mutex.new
  @converters_mutex = Mutex.new

  def self.configure
    yield configuration if block_given?
  end

  def self.configuration
    return @config if defined?(@config) && @config

    @config_mutex.synchronize do
      @config ||= Leafy::Configuration.new
    end
  end

  def self.register_converter(name, converter)
    raise(ArgumentError, "converter is not provided") if converter.nil?

    if !converter.respond_to?(:load) || !converter.respond_to?(:dump)
      raise(ArgumentError, "converter must respond to #dump and #load")
    end

    converters[name] = converter
  end

  def self.converters
    return @converters if defined?(@converters) && @converters

    @converters_mutex.synchronize do
      @converters ||= {}
    end
  end
end

Leafy.register_converter(:dummy, Leafy::Converter::DummyConverter.new)
Leafy.register_converter(:string, Leafy::Converter::StringConverter.new)
Leafy.register_converter(:integer, Leafy::Converter::IntegerConverter.new)
Leafy.register_converter(:double, Leafy::Converter::DoubleConverter.new)
Leafy.register_converter(:datetime, Leafy::Converter::DatetimeConverter.new)
Leafy.register_converter(:bool, Leafy::Converter::BoolConverter.new)
Leafy.register_converter(:date, Leafy::Converter::DateConverter.new)
