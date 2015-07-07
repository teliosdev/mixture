# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the DateTime class.
    class DateTime < Base
      type Type::DateTime

      coerce_to(Type::String, &:to_s)
    end
  end
end
