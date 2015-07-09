# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Set class.
    class Set < Base
      type Type::Set

      coerce_to(Type::Object, Itself)
      coerce_to(Type::Set, :dup)
      coerce_to(Type::Array, :to_a)
    end
  end
end
