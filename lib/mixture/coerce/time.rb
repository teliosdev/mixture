# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Time class.
    class Time < Base
      type Type::Time

      coerce_to(Type::String, &:to_s)
    end
  end
end
