module Leafy
  module Mixin
    module DataAccessor

      module ClassMethods
        def leafy_data_attribute=(value)
          @leafy_data_attribute = value
        end

        def leafy_data_attribute
          @leafy_data_attribute ||= :leafy_data
        end

        def leafy_data_getter; leafy_data_attribute; end

        def leafy_data_setter; "#{leafy_data_attribute}="; end
      end

      module InstanceMethods
        private

        def _leafy_data=(value)
          unless respond_to?(self.class.leafy_data_setter)
            raise(RuntimeError, "must respond to ##{self.class.leafy_data_setter}") unless respond_to?(:leafy_data=)
          end

          public_send(self.class.leafy_data_setter, value)
        end

        def _leafy_data
          unless respond_to?(self.class.leafy_data_getter)
            raise(RuntimeError, "must respond to ##{self.class.leafy_data_getter}")
          end

          public_send(self.class.leafy_data_getter)
        end
      end

    end
  end
end