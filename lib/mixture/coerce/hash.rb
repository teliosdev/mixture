# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Coerce
    # Handles coercion of the Hash class.
    class Hash < Base
      type Types::Hash

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Boolean, :any?)

      coerce_to(Types::Hash) do |value, type|
        members = type.options.fetch(:members)
        ::Hash[value.map do |k, v|
          [Coerce.perform(members[0], k),
           Coerce.perform(members[1], v)]
        end]
      end
    end
  end
end
