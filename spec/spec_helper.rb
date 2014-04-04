require 'bundler'
Bundler.setup

require 'redis_field'
require 'redis_field/testing'

RedisField::Base.redis = Redis.new db: 15
ENV['RAILS_ENV'] = 'test'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do
  create_table :test_users do |t|
    t.string :name
    t.timestamps
  end
end

class TestUser < ActiveRecord::Base; end