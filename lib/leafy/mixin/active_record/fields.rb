# frozen_string_literal: true

require "active_record"

module Leafy
  module Mixin
    module ActiveRecord

      module Fields
        module ClassMethods
        end

        module InstanceMethods

          def leafy_fields
            raise(RuntimeError, "Leafy: leafy_fields method is not defined")
          end

          def leafy_values
            leafy_field_values.values
          end

          def leafy_values=(attributes = {})
            field_value_list = leafy_field_values
            field_value_list.values = attributes

            self.leafy_data = ::Leafy::FieldValueCollection.dump(field_value_list)
          end

          def leafy_field_values
            ::Leafy::FieldValueCollection.load(leafy_fields, leafy_data || "{}")
          end
        end
      end

    end
  end
end
