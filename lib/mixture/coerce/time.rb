# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Time class.
    class Time < Base
      type Types::Time

      coerce_to(Types::Object, Itself)
      coerce_to(Types::String, :to_s)
      coerce_to(Types::Integer, :to_i)
      coerce_to(Types::Float, :to_f)
      coerce_to(Types::Rational, :to_r)
      coerce_to(Types::Array, :to_a)
      coerce_to(Types::Time, Itself)
      coerce_to(Types::Date, :to_date)
      coerce_to(Types::DateTime, :to_datetime)
    end
  end
end
