# frozen_string_literal: true

module Leafy
  module Mixin
    module Poro

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

            self._leafy_data = ::Leafy::FieldValueCollection.dump(field_value_list)
          end

          def leafy_field_values
            ::Leafy::FieldValueCollection.load(leafy_fields, _leafy_data || "{}")
          end
        end
      end

    end
  end
end
