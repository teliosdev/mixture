# encoding: utf-8

module Mixture
  module Types
    # A numeric.  This is inherited by {Integer}, {Float}, and
    # {Rational}.  Those should be used for coercion instead of this.
    # This just helps represent the type hirearchy.
    class Numeric < Object
      options[:primitive] = ::Numeric
    end
  end
end
