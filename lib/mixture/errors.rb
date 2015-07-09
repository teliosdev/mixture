# encoding: utf-8

module Mixture
  # All mixture errors inherit this.
  class BasicError < StandardError
  end

  # Occurs when a value can't be coerced into another value.
  class CoercionError < BasicError
  end

  # Occurs when a validation fails.
  class ValidationError < BasicError
  end
end
