# encoding: utf-8

require "mixture/coerce/base"
require "mixture/coerce/array"
require "mixture/coerce/date"
require "mixture/coerce/datetime"
require "mixture/coerce/float"
require "mixture/coerce/hash"
require "mixture/coerce/integer"
require "mixture/coerce/nil"
require "mixture/coerce/object"
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
      @_coercers ||= {}
    end

    # Returns a block that takes one argument: the value.
    #
    # @param from [Mixture::Type]
    #   The type to coerce from.
    # @param to [Mixture::Type]
    #   The type to coerce to.
    # @return [Proc{(Object) => Object}]
    def self.coerce(from, to)
      coercers
        .fetch(from) { fail CoercionError, "No coercer for #{from}" }
        .to(to)
    end

    # Registers the default coercions.
    def self.load
      register Array
      register Date
      register DateTime
      register Float
      register Hash
      register Integer
      register Nil
      register Object
      register Rational
      register Set
      register String
      register Symbol
      register Time
    end

    load
  end
end
