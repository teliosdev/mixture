# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Coerce
    # A class coercion.
    class Class < Base
      type Types::Class

      coerce_to(Types::Object, Itself)
      coerce_to(Types::Class) do |value, type|
        member = type.options.fetch(:members).first
        unless value.is_a?(member)
          fail CoercionError, "Cannot coerce #{value.class} =>" \
               " #{member}"
        end
        value
      end
    end
  end
end
