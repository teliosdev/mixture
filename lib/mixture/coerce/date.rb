# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Date class.
    class Date < Base
      type Type::Date

      coerce_to(Type::String, &:to_s)
    end
  end
end
