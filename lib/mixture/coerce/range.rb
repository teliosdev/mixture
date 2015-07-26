# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Integer class.
    class Range < Base
      type Types::Range

      coerce_to(Types::Object, Itself)
      coerce_to(Types::String, :to_s)
      coerce_to(Types::Array, :to_a)
    end
  end
end
