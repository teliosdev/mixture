# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Coerce
    # Handles coercion of the Array class.
    class Array < Base
      type Types::Array

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Boolean, :any?)

      coerce_to(Types::Array) do |value, type|
        member = type.options.fetch(:members).first
        value.map { |e| Coerce.perform(member, e) }
      end

      coerce_to(Types::Set) do |value, type|
        member = type.options.fetch(:members).first
        value.map { |e| Coerce.perform(member, e) }
      end

      coerce_to(Types::Hash) do |value, type|
        member = type.options.fetch(:members)
        ::Hash[value.map do |element|
          [Coerce.perform(member[0], element[0]),
           Coerce.perform(member[1], element[1])]
        end]
      end
    end
  end
end
