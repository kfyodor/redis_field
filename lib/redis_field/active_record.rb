module RedisField
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    def redis_fields
      self.class.redis_fields || []
    end

    def get_redis_fields
      redis_fields.each do |field_name|
        send "#{field_name}=", Base.new(self, field_name).get
      end
    end

    def sync_redis_fields!
      redis_fields.each do |field_name|
        if send(field_name).present?
          Base.new(self, field_name).set send(field_name)
        end
      end
    end

    module ClassMethods
      def redis_fields
        @redis_fields || []
      end

      def redis_fields=(*field_names)
      end

      def has_redis_fields(*field_names)
        fields = redis_fields
        @redis_fields = (fields + field_names).uniq
        field_names = field_names - fields

        after_save       :sync_redis_fields!
        after_initialize :get_redis_fields
        
        init_accessors(*field_names)
      end
      alias_method :has_redis_field, :has_redis_fields

      def init_accessors(*field_names)
        field_names.each do |field_name|
          v = "#{field_name}_redis_value"

          attr_accessor v

          alias_method "#{field_name}", v
          alias_method "#{field_name}=", "#{v}="
        end
      end
    end
  end
end