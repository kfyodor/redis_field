module RedisField
  module Testing
    extend self

    def reset_keys!
      unless Base.env == 'test'
        raise 'Key could be resetted only in test environment'
      end

      path = [Base.path_prefix, Base.env].join ':'
      keys = Base.redis.keys.grep(/^#{path}.+/)
      Base.redis.del *keys if keys.any?
    end
  end
end