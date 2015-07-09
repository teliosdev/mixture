# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Date class.
    class Date < Base
      type Type::Date

      coerce_to(Type::Object, Itself)
      coerce_to(Type::String, :to_s)
      coerce_to(Type::Time, :to_time)
      coerce_to(Type::Date, :to_date)
      coerce_to(Type::DateTime, :to_datetime)
      coerce_to(Type::Array) { |value| value.to_time.to_a }
      coerce_to(Type::Float) { |value| value.to_time.to_f }
      coerce_to(Type::Integer) { |value| value.to_time.to_i }
      coerce_to(Type::Rational) { |value| value.to_time.to_r }
    end
  end
end
