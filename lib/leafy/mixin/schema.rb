# frozen_string_literal: true

module Leafy
  module Mixin
    module Schema

      def self.[](orm = :poro)
        case orm
        when :poro
          include Poro::InstanceMethods
          extend Poro::ClassMethods
        when :active_record
          include ActiveRecord::InstanceMethods
          extend ActiveRecord::ClassMethods
        else
          raise(RuntimeError, "Leafy: unsupported schema storage: #{orm}")
        end
      end

    end
  end
end
