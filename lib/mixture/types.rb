# encoding: utf-8
# frozen_string_literal: true

require "thread_safe"

module Mixture
  # Contains information about types.
  module Types
    # A list of all of the types (non-anonymous) that are known.
    #
    # @return [Array<Class>]
    def self.types
      @types ||= ThreadSafe::Array.new
    end

    # A list of the mappings that all types have.  This is used
    # primarily to map a type's symbol name to its type (e.g.
    # `:string` to `String`).  This is also used for boolean mapping.
    #
    # @return [Hash{Symbol => Mixture::Types::Type}]
    def self.mappings
      ::Hash[types.flat_map do |type|
        type.mappings.map do |name|
          [name, type]
        end
      end]
    end

    # Infers an object's type.  It first checks the mappings to see if
    # the object given is in the mappings; if it's not, it checks if
    # it is a class.  If it is a class, it passes it over to
    # {.infer_class}; otherwise, it passes it over to {.infer_type}.
    #
    # @see .mappings
    # @see .infer_class
    # @see .infer_type
    # @param object [Object] The object to infer the type of.
    # @return [Mixture::Types::Type] The type of the object.
    def self.infer(object)
      mappings.fetch(object) do
        if object.is_a?(::Class)
          infer_class(object)
        else
          infer_type(object)
        end
      end
    end

    # Infers the class of the given object.  If the object is a type,
    # it just returns the object.  Otherwise, it searches types for a
    # primitive that matches the object.  If one is found, it is
    # returned; otherwise, a new `Class` type is created using
    # {Class.[]}.  This is primarily used for user-defined classes.
    #
    # @example Creating a type for a user-defined class.
    #   class MyClass; end
    #   Mixture::Types.infer(MyClass) # => Mixture::Types::Class[MyClass]
    # @api private
    # @see Class.[]
    # @param object [Class] The object to infer the type of.
    # @return [Mixture::Types::Type] The type of the object.
    def self.infer_class(object)
      return object if object <= Type
      types.find { |type| type.options[:primitive] == object } || Class[object]
    end

    # Infers the type of the object.  If the object is an array or set,
    # it returns an {Array} or {Set} type with the object's first
    # element's type as the member type.  Otherwise, it tries to find
    # a type that matches the object using {Type.matches?}.  This will
    # almost always return a type, if not {Object}.
    #
    # @note This may not return a type if the object is a
    #   {BasicObject}.  This is because of the constraints on the
    #   {Object} type.
    # @example Infers the type of an array of elements.
    #   Mixture::Types.infer([1])
    #   # => Mixture::Types::Array[Mixture::Types::Integer]
    # @api private
    # @param object [Object]  The object to infer.
    # @return [Mixture::Types::Type] The inferred type.
    def self.infer_type(object)
      case object
      when ::Array then Array[object.first]
      when ::Set   then Set[object.first]
      when ::Hash  then Hash[object.keys.first => object.values.first]
      else
        types.find { |type| type.matches?(object) } ||
          infer_class(object.class)
      end
    end
  end
end

require "mixture/types/type"
require "mixture/types/access"
require "mixture/types/object"
require "mixture/types/enumerable"
require "mixture/types/collection"
require "mixture/types/boolean"
require "mixture/types/class"
require "mixture/types/numeric"
require "mixture/types/array"
require "mixture/types/date"
require "mixture/types/datetime"
require "mixture/types/float"
require "mixture/types/hash"
require "mixture/types/integer"
require "mixture/types/nil"
require "mixture/types/range"
require "mixture/types/rational"
require "mixture/types/set"
require "mixture/types/string"
require "mixture/types/symbol"
require "mixture/types/time"
