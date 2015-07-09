# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Array class.
    class Array < Base
      type Type::Array

      coerce_to(Type::Object, Itself)
      coerce_to(Type::Array, Itself)
      coerce_to(Type::Set, :to_set)
      coerce_to(Type::Hash) { |value| ::Hash[value] }
    end
  end
end
