# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Rational class.
    class Rational < Base
      type Types::Rational

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Rational, Itself)
      coerce_to(Types::Time) { |value| ::Time.at(value) }
      coerce_to(Types::Date) { |value| ::Time.at(value).to_date }
      coerce_to(Types::DateTime) { |value| ::Time.at(value).to_datetime }
      coerce_to(Types::Float, :to_f)
      coerce_to(Types::Integer, :to_i)
      coerce_to(Types::String, :to_s)
    end
  end
end
