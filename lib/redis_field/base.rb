module RedisField
  class Base
    class_attribute :redis, :path_prefix, :env
    attr_writer     :model_id

    # TODO: move to config class
    class << self
      def path_prefix
        @@path_prefix ||= 'ar_redis_field'
      end

      def redis
        @@redis ||= Redis.new
      end

      def env
        @@env ||= ENV['RAILS_ENV'] || "development"
      end      
    end

    def initialize(object, field_name)
      @object, @field_name = object, field_name
    end

    def set(value)
      redis.set @field_name, Marshal.dump(value)
    end

    def get
      Marshal.load field_path if field_path
    end

    private

    def object_model_name
      @object_model_name ||= @object.class.model_name.param_key
    end

    def model_id
      @model_id ||= @object.id
    end

    def redis
      @redis ||= Redis::Namespace.new(redis_path, redis: self.class.redis)
    end

    def redis_path
      [
        self.class.path_prefix, 
        env, 
        object_model_name, 
        model_id
      ].join ':'
    end

    def field_path
      redis[@field_name]
    end

    def env
      self.class.env
    end
  end
end