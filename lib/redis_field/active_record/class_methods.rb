require 'redis_field/dirty_field_set'

module RedisField
  module ActiveRecord
    module ClassMethods

      def redis_fields
        @redis_fields ||= DirtyFieldSet.new
      end

      def has_redis_fields(*field_names)
        redis_fields.add(*field_names)

        init_redis_field_callbacks
        init_redis_field_accessors
      end 
      alias_method :has_redis_field, :has_redis_fields

      private

      def init_redis_field_callbacks
        unless @_redis_fields_callbacks_initted
          class_eval do
            after_save       :sync_redis_fields!
            after_create     :sync_redis_fields!
            after_initialize :get_redis_fields
          end
          @_redis_fields_callbacks_initted = true
        end
      end

      def init_redis_field_accessors
        redis_fields.changes.each do |field_name|
          method_name = :"#{field_name}_redis_value"

          class_eval do 
            attr_accessor method_name
          end

          alias_method :"#{field_name}", method_name
          alias_method :"#{field_name}=", :"#{method_name}="
        end
      end

    end
  end
end