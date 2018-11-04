# frozen_string_literal: true

module Leafy
  module Mixin
    module Poro

      module Schema

        module InstanceMethods
          def leafy_fields
            data = _leafy_data
            Leafy::Schema.load(data.nil? ? "[]" : data)
          end

          def leafy_fields=(leafy_schema)
            self._leafy_data = ::Leafy::Schema.dump(leafy_schema)
          end

          def leafy_fields_attributes=(attributes_list)
            self.leafy_fields = ::Leafy::Schema.new(attributes_list)
          end
        end

        module ClassMethods
        end

      end

    end
  end
end
