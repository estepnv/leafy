# frozen_string_literal: true

require_relative "./data_accessor"

module Leafy
  module Mixin
    module Fields

      def self.[](orm = :poro)
        Module.new do
          @orm = orm

          def self.included(base)

            base.extend DataAccessor::ClassMethods
            base.include DataAccessor::InstanceMethods

            case @orm

            when :poro

              require_relative "./poro/fields"

              base.extend Poro::Fields::ClassMethods
              base.include Poro::Fields::InstanceMethods

            when :active_record

              require_relative "./active_record/shared"
              require_relative "./active_record/fields"

              base.extend ActiveRecord::Fields::ClassMethods
              base.include ActiveRecord::Shared::InstanceMethods
              base.include ActiveRecord::Fields::InstanceMethods

            else

              raise(RuntimeError, "Leafy: unsupported schema storage: #{orm}")

            end
          end

        end
      end

    end
  end
end
