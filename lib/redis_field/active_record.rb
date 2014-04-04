require 'redis_field/active_record/class_methods'

module RedisField
  module ActiveRecord
    extend ActiveSupport::Concern

    included do
      extend ClassMethods
    end

    def redis_fields
      self.class.redis_fields
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
  end
end