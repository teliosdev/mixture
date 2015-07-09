# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Time class.
    class Time < Base
      type Type::Time

      coerce_to(Type::String, :to_s)
      coerce_to(Type::Integer, :to_i)
      coerce_to(Type::Float, :to_f)
      coerce_to(Type::Rational, :to_r)
      coerce_to(Type::Array, :to_a)
      coerce_to(Type::Time, Itself)
      coerce_to(Type::Date, :to_date)
      coerce_to(Type::DateTime, :to_datetime)
    end
  end
end
