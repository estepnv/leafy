# frozen_string_literal: true

module Leafy
  module Mixin
    module Schema

      def self.[](orm)
        Module.new do
          @orm = orm

          def self.included(base)
            base.extend DataAccessor::ClassMethods
            base.include DataAccessor::InstanceMethods

            case @orm
            when :poro
              base.extend Poro::ClassMethods
              base.include Poro::InstanceMethods
            when :active_record
              base.extend ActiveRecord::ClassMethods
              base.include ActiveRecord::InstanceMethods
            else
              raise(RuntimeError, "Leafy: unsupported schema storage: #{orm}")
            end
          end

        end
      end

    end
  end
end
