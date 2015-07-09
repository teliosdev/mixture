# encoding: utf-8

require "set"
require "time"
require "date"

# The mixture module.
module Mixture
  # An undefined value.  This is used in place so that we can be sure
  # that an argument wasn't passed.
  #
  # @return [Object]
  Undefined = Object.new.freeze

  # A proc that returns its first argument.
  #
  # @return [Proc{(Object) => Object}]
  Itself = proc { |value| value }

  require "mixture/version"
  require "mixture/errors"
  require "mixture/type"
  require "mixture/attribute"
  require "mixture/attribute_list"
  require "mixture/coerce"
  require "mixture/validate"
  require "mixture/extensions"
  require "mixture/type"
end
