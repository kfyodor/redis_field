require 'active_record'
require 'redis'
require 'redis/namespace'

require 'redis_field/base'
require 'redis_field/adapters/active_record'
require 'redis_field/version'

module RedisField
  class NotCompatibleError < StandardError; end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send :include, RedisField::Adapters::ActiveRecord
else
  raise RedisField::NotCompatibleError
end