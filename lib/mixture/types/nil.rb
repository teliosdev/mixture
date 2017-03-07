# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Types
    # Represents a nil type.  This has no coercions.
    class Nil < Object
      register
      options[:primitive] = ::NilClass
      as nil
    end
  end
end
