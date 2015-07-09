# encoding: utf-8

require "forwardable"

module Mixture
  # A type.  This can be represented as a constant.  This is normally
  # anything that inherits `Class`.  One instance per type.
  class Type
    extend Forwardable
    @instances = {}
    # A class to represent the Boolean type (i.e. true, false), since
    # ruby doesn't have a Boolean class.
    #
    # @return [Class]
    BooleanClass = Class.new

    # Ancestors that two classes might have in common with each other.
    #
    # @return [Array<Module, Class>]
    COMMON_ANCESTORS = BooleanClass.ancestors - [BooleanClass]

    # The builtin types of Ruby.  These are initialized as types
    # before anything else happens.
    #
    # @return [Array<Symbol>]
    BUILTIN_TYPES = %w(
      Object Array Hash Integer Rational Float Set String Symbol
      Time Date DateTime
    ).map(&:intern).freeze

    # The aliases for types.  This overrides any other possible
    # inferences that this class can make.  For example, `true` and
    # `false` are automatically mapped to `BooleanClass`.
    #
    # @return [Hash{Object, Symbol => Class}]
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
    # given is a class, and passes it to `#new` - which will error if
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
    # the given type is listed in {TYPE_ALIASES}, it uses the alias
    # value for a lookup.  If the given type is a {Type}, it returns
    # the type.  If the given type is a `Class`, it uses {.infer_class}.
    # Otherwise, it uses {.infer_class} on the type's class.
    #
    # @example
    #   Mixture::Type.infer(Integer) # => Mixture::Type::Integer
    #
    # @example
    #   Mixture::Type.infer(1) # => Mixture::Type::Integer
    #
    # @example
    #   Mixture::Type.infer(MyClass) # => Mixture::Type[MyClass]
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

    # Infer a classes' type.  If the class is a type, it returns the
    # type.  Otherwise, it checks the most basic ancestors (most basic
    # ancestors being any ancestors not shared with a new class) for
    # any classes that have a {Type}; if there are none, it creates a
    # new type from the class.
    #
    # @param klass [Class] The class to infer type from.
    # @return [Mixture::Type]
    def self.infer_class(klass)
      if klass.is_a?(Type)
        klass
      else
        basic_ancestors = klass.ancestors - COMMON_ANCESTORS
        from(basic_ancestors.find { |a| @instances.key?(a) } || klass)
      end
    end

    # Loads the builtin types.  This includes `Boolean` and `Nil`.
    #
    # @see BUILTIN_TYPES
    # @see BooleanClass
    # @return [void]
    def self.load
      BUILTIN_TYPES.each do |sym|
        const_set(sym, from(::Object.const_get(sym)))
      end

      @instances[BooleanClass] = new(BooleanClass, name: "Boolean")
      const_set("Boolean", @instances[BooleanClass])
      @instances[NilClass] = new(NilClass, name: "Nil")
      const_set("Nil", @instances[NilClass])
    end

    # The name of the type.  If this wasn't provided upon
    # initialization, it is guessed to be the class's name, which is
    # normally good enough.
    #
    # @return [String]
    attr_reader :name

    # Initialize the type.  The class given _must_ be a class;
    # otherwise, it will error.  A name can be provided as an option.
    #
    # @param type [Class] The type to create.
    # @param options [Hash{Symbol => Object}] The options.
    # @option options [String] :name The name to provide the type
    #   with.  If this is not provided, it uses the class name.
    def initialize(type, options = {})
      fail ArgumentError, "Expected a Class, got #{type.class}" unless
        type.is_a?(Class)
      @type = type
      @name = options.fetch(:name, @type.name)
    end

    # Creates a string representation of the type.  This normally has
    # the format `Mixture::Type(Class)`, where `Class` is the class.
    #
    # @return [String]
    def to_s
      "#{self.class.name}(#{@name})"
    end
    alias_method :inspect, :to_s

    # Creates a `:to_` method name for the type.
    #
    # @example
    #   Mixture::Type[Array].method_name # => :to_array
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
