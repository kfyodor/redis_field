require 'active_record'
require 'redis'
require 'redis/namespace'

require 'redis_field/base'
require 'redis_field/active_record'
require 'redis_field/version'

module RedisField
  # more detailed explanation
  class NotCompatibleError < StandardError; end
end

if defined?(ActiveRecord::Base)
  # railtie?
  ActiveRecord::Base.send :include, RedisField::ActiveRecord
else
  raise RedisField::NotCompatibleError
end