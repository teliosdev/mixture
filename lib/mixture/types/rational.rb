# encoding: utf-8

module Mixture
  module Types
    # A rational.  I've personally never used this, but I don't see it
    # as a bad thing.
    class Rational < Numeric
      register
      options[:primitive] = ::Rational
      options[:method] = :to_rational
      as :rational
    end
  end
end
