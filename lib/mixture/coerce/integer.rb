# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Integer class.
    class Integer < Base
      type Type::Integer

      coerce_to(Type::String, &:to_s)
    end
  end
end
