# encoding: utf-8

module Mixture
  # Handles coercion of objects.
  module Coerce
    # A hash of the coercers that currently exist.  This maps their
    # types to their classes.
    #
    # @return [Hash{Mixture::Type => Mixture::Coerce::Base}]
    COERCERS = {}

    # Registers a coercion with the module.  This uses the {COERCERS}
    # constant.
    #
    # @param coercion [Mixture::Coerce::Base] The coercer to register.
    # @return [void]
    def self.register(coercion)
      COERCERS[coercion.type] = coercion
    end

    # Returns a block that takes one argument: the value.
    #
    # @param from [Mixture::Type]
    #   The type to coerce from.
    # @param to [Mixture::Type]
    #   The type to coerce to.
    # @return [Proc{(Object) => Object}]
    def self.coerce(from:, to:)
    end
  end
end

require "mixture/coerce/base"
require "mixture/coerce/array"
require "mixture/coerce/date"
require "mixture/coerce/datetime"
require "mixture/coerce/float"
require "mixture/coerce/hash"
require "mixture/coerce/integer"
require "mixture/coerce/numeric"
require "mixture/coerce/object"
require "mixture/coerce/set"
require "mixture/coerce/string"
require "mixture/coerce/symbol"
require "mixture/coerce/time"
