require 'redis_field/dirty_field_set'

module RedisField
  module ActiveRecord
    module ClassMethods
      def redis_fields
        @redis_fields ||= DirtyFieldSet.new
      end

      def has_redis_fields(*field_names)
        redis_fields.add(*field_names)

        after_save       :sync_redis_fields!
        after_initialize :get_redis_fields
        
        init_accessors
      end
      alias_method :has_redis_field, :has_redis_fields

      def init_accessors
        redis_fields.changes.each do |field_name|
          v = "#{field_name}_redis_value"

          class_eval { attr_accessor v }

          alias_method "#{field_name}", v
          alias_method "#{field_name}=", "#{v}="
        end
      end
    end
  end
end