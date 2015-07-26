# encoding: utf-8

module Mixture
  module Coerce
    # A class coercion.
    class Class < Base
      type Types::Class

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Class) do |value, type|
        member = type.options.fetch(:members).first
        fail CoercionError, "Cannot coerce #{value.class} =>" \
             " #{member}" unless value.is_a?(member)
        value
      end
    end
  end
end
