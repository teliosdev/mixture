# encoding: utf-8

module Mixture
  module Coerce
    # Handles coercion of the Object class.
    class Object < Base
      type Type::Object

      coerce_to(Type::String, &:to_s)
    end
  end
end
