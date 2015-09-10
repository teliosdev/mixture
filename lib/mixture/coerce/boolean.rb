# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the boolean classes.
    class Boolean < Base
      type Types::Boolean

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Boolean, Itself)
      coerce_to(Types::Integer) { |value| value ? 1 : 0 }
    end
  end
end
