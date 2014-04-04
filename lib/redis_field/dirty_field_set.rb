require 'set'

module RedisField
  class DirtyFieldSet
    def initialize
      @changes     = Set.new
      @field_names = Set.new
    end

    def field_names
      @field_names.to_a
    end

    def changes
      @changes.to_a
    end

    def each(&block)
      field_names.each(&block)
    end

    def add(*new_field_names)
      new_field_names  = Set.new(new_field_names)
      @changes         = new_field_names - @field_names
      @field_names     = @field_names + new_field_names
    end
  end
end