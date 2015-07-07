# encoding: utf-8

require "forwardable"

module Mixture
  # A type.  This can be represented as a constant.  This is normally
  # anything that inherits `Class`.  One instance per type.
  class Type
    @instances = {}

    private_class_method :new

    def self.from(type)
      @instances.fetch(type) do
        @instances[type] = new(type)
      end
    end

    def self.[](type)
      from(type)
    end

    delegate name: :@type
    alias_method :to_s, :name

    def initialize(type)
      fail ArgumentError, "Expected a Class, got #{type.class}" unless
        type.is_a?(Class)
      @type = type
    end

    def to_s
      @type.name
    end
  end
end

Mixture::Type::Boolean = Mixture::Type.new(Class.new)

%w(
  Object Array Hash Integer Numeric Float Set String Symbol Time Date DateTime
).each do |sym|
  Mixture::Type.const_set(sym, Mixture::Type.from(Object.const_get(sym)))
end
