# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Nil class.
    class Nil < Base
      type Type::Nil

      coerce_to(Type::Object, Itself)
      coerce_to(Type::String) { "" }
      coerce_to(Type::Array) { [] }
      coerce_to(Type::Float) { 0.0 }
      coerce_to(Type::Hash) { {} }
      coerce_to(Type::Integer) { 0 }
      coerce_to(Type::Rational) { Rational(0, 1) }
      coerce_to(Type::Set) { Set.new }
      coerce_to(Type::Symbol) { :"" }
    end
  end
end
