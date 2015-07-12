# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Set class.
    class Set < Base
      type Types::Set

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Set) do |value, type|
        member = type.options.fetch(:members).first
        value.map { |e| Coerce.perform(member, e) }.to_set
      end

      coerce_to(Types::Array) do |value, type|
        member = type.options.fetch(:members).first
        value.map { |e| Coerce.perform(member, e) }.to_a
      end
    end
  end
end
