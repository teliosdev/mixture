# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Numeric class.
    class Numeric < Base
      type Type::Numeric

      coerce_to(Type::String, &:to_s)
    end
  end
end
