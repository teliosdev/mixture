# encoding: utf-8

module Mixture
  module Coerce
    # A class coercion.
    class Class < Base
      type Types::Class

      coerce_to(Types::Object, Itself)
    end
  end
end
