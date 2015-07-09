# encoding: utf-8

require "forwardable"

module Mixture
  # A type.  This can be represented as a constant.  This is normally
  # anything that inherits `Class`.  One instance per type.
  class Type
    extend Forwardable
    @instances = {}
    BooleanClass = Class.new
    InstanceClass = Class.new

    BUILTIN_TYPES = %w(
      Object Array Hash Integer Rational Float Set String Symbol
      Time Date DateTime
    ).map(&:intern).freeze

    TYPE_ALIASES = {
      true => BooleanClass,
      false => BooleanClass,
      nil => NilClass,
      nil: NilClass,
      bool: BooleanClass,
      boolean: BooleanClass,
      str: ::String,
      string: ::String,
      int: ::Integer,
      integer: ::Integer,
      rational: ::Rational,
      float: ::Float,
      array: ::Array,
      set: ::Set,
      symbol: ::Symbol,
      time: ::Time,
      date_time: ::DateTime,
      date: ::Date
    }.freeze

    # Protect our class from being initialized by accident by anyone
    # who doesn't know what they're doing.  They would have to try
    # really hard to initialize this class, and in which case, that
    # is acceptable.
    private_class_method :new

    # Returns a {Type} from a given class.  It assumes that the type
    # given is a class, and passes it to {#new} - which will error if
    # it isn't.
    #
    # @param type [Class] A type.
    # @return [Mixture::Type]
    def self.from(type)
      @instances.fetch(type) do
        @instances[type] = new(type)
      end
    end

    # (see .from)
    def self.[](type)
      from(type)
    end

    # Determines the best type that represents the given value.  If
    # the given value is a {Type}, it returns the value.  If the
    # given value is already defined as a {Type}, it returns the
    # {Type}.  If the value's class is already defined as a {Type},
    # it returns the class's {Type}; otherwise, it returns the types
    # for Class and Object, depending on if the value is a Class or
    # not, respectively.
    #
    # @example
    #   Mixture::Type.infer(Integer) # => Mixture::Type::Integer
    #
    # @example
    #   Mixture::Type.infer(1) # => Mixture::Type::Integer
    #
    # @example
    #   Mixture::Type.infer(MyClass) # => Mixture::Type::Instance
    #
    # @example
    #   Mixture::Type.infer(Object.new) # => Mixture::Type::Object
    #
    # @param value [Object] The value to infer.
    # @return [Mixture::Type]
    def self.infer(value)
      case
      when TYPE_ALIASES.key?(value) then from(TYPE_ALIASES[value])
      when value.is_a?(Type)        then value
      when value.is_a?(Class)       then infer_class(value)
      else infer_class(value.class)
      end
    end

    def self.infer_class(klass)
      if klass.is_a?(Type)
        klass
      else
        basic_ancestors = klass.ancestors - ancestors
        from(basic_ancestors.find { |a| @instances.key?(a) } || klass)
      end
    end

    def self.load
      BUILTIN_TYPES.each do |sym|
        const_set(sym, from(::Object.const_get(sym)))
      end

      @instances[BooleanClass] = new(BooleanClass, name: "Boolean")
      const_set("Boolean", @instances[BooleanClass])
      @instances[InstanceClass] = new(InstanceClass, name: "Instance")
      const_set("Instance", @instances[InstanceClass])
      @instances[NilClass] = new(NilClass, name: "Nil")
      const_set("Nil", @instances[NilClass])
    end

    attr_reader :name

    def initialize(type, name: nil)
      fail ArgumentError, "Expected a Class, got #{type.class}" unless
        type.is_a?(Class)
      @type = type
      @name = name || @type.name
    end

    def to_s
      "#{self.class.name}(#{@name})"
    end
    alias_method :inspect, :to_s

    def method_name
      @_method_name ||= begin
        body = name
               .gsub(/^([A-Z])/) { |m| m.downcase }
               .gsub(/::([A-Z])/) { |_, m| "_#{m.downcase}" }
               .gsub(/([A-Z])/) { |m| "_#{m.downcase}" }
        :"to_#{body}"
      end
    end
  end
end

Mixture::Type.load
