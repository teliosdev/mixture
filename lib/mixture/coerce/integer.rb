# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Integer class.
    class Integer < Base
      type Type::Integer

      coerce_to(Type::Object, Itself)
      coerce_to(Type::String, :to_s)
      coerce_to(Type::Float, :to_f)
      coerce_to(Type::Rational, :to_r)
      coerce_to(Type::Integer, Itself)
      coerce_to(Type::Time) { |value| ::Time.at(value) }
      coerce_to(Type::Date) { |value| ::Time.at(value).to_date }
      coerce_to(Type::DateTime) { |value| ::Time.at(value).to_datetime }
    end
  end
end