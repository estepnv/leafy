# frozen_string_literal: true

require_relative "./data_accessor"

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

              require_relative "./poro/schema"

              base.extend Poro::Schema::ClassMethods
              base.include Poro::Schema::InstanceMethods

            when :active_record

              require_relative "./active_record/shared"
              require_relative "./active_record/schema"

              base.extend ActiveRecord::Schema::ClassMethods
              base.include ActiveRecord::Shared::InstanceMethods
              base.include ActiveRecord::Schema::InstanceMethods

            else

              raise(RuntimeError, "Leafy: unsupported schema storage: #{orm}")

            end
          end

        end
      end

    end
  end
end
