# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the String class.
    class String < Base
      type Type::String

      coerce_to(Type::Object, Itself)
      coerce_to(Type::String, :dup)
      coerce_to(Type::Symbol, :to_sym)
      coerce_to(Type::Integer, :to_i)
      coerce_to(Type::Float, :to_f)
      coerce_to(Type::Time) { |value| ::Time.parse(value) }
      coerce_to(Type::Date) { |value| ::Date.parse(value) }
      coerce_to(Type::DateTime) { |value| ::DateTime.parse(value) }
    end
  end
end
