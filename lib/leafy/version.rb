# frozen_string_literal: true

module Leafy
  def self.version
    Gem::Version.new VERSION::STRING
  end

  module VERSION
    MAJOR = 0
    MINOR = 2
    TINY  = 0
    PRE   = nil

    STRING = [MAJOR, MINOR, TINY, PRE].compact.join(".")
  end
end
