# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Coerce
    # Handles coercion of the Nil class.
    class Nil < Base
      type Types::Nil

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Nil, Itself)
      coerce_to(Types::Boolean, Refute)
      coerce_to(Types::String) { "" }
      coerce_to(Types::Array) { [] }
      coerce_to(Types::Float) { 0.0 }
      coerce_to(Types::Hash) { {} }
      coerce_to(Types::Integer) { 0 }
      coerce_to(Types::Rational) { Rational(0, 1) }
      coerce_to(Types::Set) { Set.new }
      coerce_to(Types::Symbol) { :"" }
    end
  end
end
