# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Float class.
    class Float < Base
      type Type::Float

      coerce_to(Type::Object, Itself)
      coerce_to(Type::String, :to_s)
      coerce_to(Type::Float, Itself)
      coerce_to(Type::Integer, :to_i)
      coerce_to(Type::Rational, :to_r)
      coerce_to(Type::Time) { |value| ::Time.at(value) }
      coerce_to(Type::Date) { |value| ::Time.at(value).to_date }
      coerce_to(Type::DateTime) { |value| ::Time.at(value).to_datetime }
    end
  end
end
