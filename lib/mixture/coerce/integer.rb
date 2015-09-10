# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Integer class.
    class Integer < Base
      type Types::Integer

      coerce_to(Types::Object, Itself)
      coerce_to(Types::String, :to_s)
      coerce_to(Types::Float, :to_f)
      coerce_to(Types::Rational, :to_r)
      coerce_to(Types::Integer, Itself)
      coerce_to(Types::Boolean) { |value| !value.zero? }
      coerce_to(Types::Time) { |value| ::Time.at(value) }
      coerce_to(Types::Date) { |value| ::Time.at(value).to_date }
      coerce_to(Types::DateTime) { |value| ::Time.at(value).to_datetime }
    end
  end
end
