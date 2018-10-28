# frozen_string_literal: true

module Leafy
  module Mixin
    module Schema

      module Poro
        module InstanceMethods
          def leafy_fields
            raise(RuntimeError, "must respond to #leafy_data") unless respond_to?(:leafy_data)
            Leafy::Schema.load(leafy_data.nil? ? "[]" : leafy_data)
          end

          def leafy_fields=(leafy_schema)
            self.leafy_data = Leafy::Schema.dump(leafy_schema)
          end

          def leafy_fields_attributes=(attributes_list)
            raise(RuntimeError, "must respond to #leafy_data=") unless respond_to?(:leafy_data=)
            self.leafy_fields = Leafy::Schema.new(attributes_list)
          end
        end

        module ClassMethods
        end
      end

    end
  end
end
