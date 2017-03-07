# encoding: utf-8
# frozen_string_literal: true

require "set"
require "time"
require "date"

# The mixture module.
module Mixture
  # An undefined value.  This is used in place so that we can be sure
  # that an argument wasn't passed.
  #
  # @example As a placeholder.
  #   def self.constraint(value = Undefined, &block)
  #     if value != Undefined
  #       constraints << value
  #     elsif block_given?
  #       constraints << block
  #     else
  #       raise ArgumentError, "Expected an argument or block"
  #     end
  #   end
  # @return [Object]
  Undefined = Object.new.freeze

  # A proc that returns its first argument.
  #
  # @return [Proc{(Object) => Object}]
  Itself = proc { |value| value }

  # A proc that returns true.
  #
  # @return [Proc{() => true}]
  Prove = proc { true }

  # A proc that returns false.
  #
  # @return [Proc{() => false}]
  Refute = proc { false }

  # Finalizes all of the Mixture modules.
  #
  # @return [void]
  def self.finalize
    Mixture::Coerce.finalize
    Mixture::Extensions.finalize
    nil
  end

  require "mixture/version"
  require "mixture/errors"
  require "mixture/types"
  require "mixture/attribute"
  require "mixture/attribute_list"
  require "mixture/coerce"
  require "mixture/validate"
  require "mixture/extensions"
  require "mixture/model"

  finalize
end
