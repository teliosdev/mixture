# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Float class.
    class Float < Base
      type Type::Float

      coerce_to(Type::String, &:to_s)
    end
  end
end
