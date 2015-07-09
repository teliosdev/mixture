# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Rational class.
    class Rational < Base
      type Type::Rational

      coerce_to(Type::Object, Itself)
      coerce_to(Type::Rational, Itself)
      coerce_to(Type::Time) { |value| ::Time.at(value) }
      coerce_to(Type::Date) { |value| ::Time.at(value).to_date }
      coerce_to(Type::DateTime) { |value| ::Time.at(value).to_datetime }
      coerce_to(Type::Float, :to_f)
      coerce_to(Type::Integer, :to_i)
      coerce_to(Type::String, :to_s)
    end
  end
end
