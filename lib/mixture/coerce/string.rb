# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the String class.
    class String < Base
      type Types::String

      coerce_to(Types::Object, Itself)
      coerce_to(Types::String, :dup)
      coerce_to(Types::Symbol, :to_sym)
      coerce_to(Types::Integer, :to_i)
      coerce_to(Types::Float, :to_f)
      coerce_to(Types::Boolean) { |value| !value.empty? }
      coerce_to(Types::Time) { |value| ::Time.parse(value) }
      coerce_to(Types::Date) { |value| ::Date.parse(value) }
      coerce_to(Types::DateTime) { |value| ::DateTime.parse(value) }
    end
  end
end
