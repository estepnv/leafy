# frozen_string_literal: true

require "active_record"

module Leafy
  module Mixin
    module ActiveRecord
      module Shared

        module InstanceMethods
          private

          def activerecord_json_column?
            return false unless self.is_a?(::ActiveRecord::Base)
            return false unless column = self.class.columns_hash[self.class.leafy_data_attribute.to_s]

            [:json, :jsonb].include?(column.type)
          end
        end

      end
    end
  end
end