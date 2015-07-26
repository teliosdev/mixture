# encoding: utf-8

require "mixture/coerce/base"
require "mixture/coerce/date"
require "mixture/coerce/array"
require "mixture/coerce/datetime"
require "mixture/coerce/float"
require "mixture/coerce/hash"
require "mixture/coerce/integer"
require "mixture/coerce/nil"
require "mixture/coerce/object"
require "mixture/coerce/range"
require "mixture/coerce/rational"
require "mixture/coerce/set"
require "mixture/coerce/string"
require "mixture/coerce/symbol"
require "mixture/coerce/time"

module Mixture
  # Handles coercion of objects.
  module Coerce
    # Registers a coercion with the module.  This uses the {.coercers}
    # constant.
    #
    # @param coercion [Mixture::Coerce::Base] The coercer to register.
    # @return [void]
    def self.register(coercion)
      coercers[coercion.type] = coercion
    end

    # A hash of the coercers that currently exist.  This maps their
    # types to their classes.
    #
    # @return [Hash{Mixture::Type => Mixture::Coerce::Base}]
    def self.coercers
      @_coercers ||= ThreadSafe::Hash.new
    end

    # Returns a block that takes one argument: the value.
    #
    # @param from [Mixture::Types::Type]
    #   The type to coerce from.
    # @param to [Mixture::Types::Type]
    #   The type to coerce to.
    # @return [Proc{(Object, Mixture::Types::Object) => Object}]
    def self.coerce(from, to)
      type = from.inheritable.find { |ancestor| coercers.key?(ancestor) }
      fail CoercionError, "No coercer for #{from}" unless type
      coercers[type].to(to)
    end

    # Performs the actual coercion, since blocks require a value and
    # type arguments.
    #
    # @param type [Mixture::Types::Type] The type to coerce to.
    # @param value [Object] The value to coerce.
    # @return [Object] The coerced value.
    def self.perform(type, value)
      to = Types.infer(type)
      from = Types.infer(value)
      block = coerce(from, to)

      begin
        block.call(value, to)
      rescue CoercionError
        raise
      rescue StandardError => e
        raise CoercionError, "#{e.class}: #{e.message}", e.backtrace
      end
    end

    # Registers the default coercions.
    #
    # @return [void]
    def self.finalize
      register Array
      register Date
      register DateTime
      register Float
      register Hash
      register Integer
      register Nil
      register Object
      register Range
      register Rational
      register Set
      register String
      register Symbol
      register Time
    end
  end
end
