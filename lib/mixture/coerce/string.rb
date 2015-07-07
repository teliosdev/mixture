# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the String class.
    class String < Base
      type Type::String

      coerce_to(Type::String, &:dup)
    end
  end
end
