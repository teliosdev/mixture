# encoding: utf-8

module Mixture
  module Types
    class Rational < Numeric
      options[:primitive] = ::Rational
      options[:method] = :to_rational
      as :rational
    end
  end
end
