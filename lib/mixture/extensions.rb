# encoding: utf-8

module Mixture
  # All of the extensions of mixture.  Handles registration of
  # extensions, so that extensions can be referend by a name instead
  # of the constant.
  module Extensions
    def self.register(name, extension)
      extensions[name.to_s.downcase.intern] = extension
    end

    def self.[](name)
      extensions.fetch(name)
    end

    def self.extensions
      @_extensions ||= {}
    end

    require "mixture/extensions/attributable"
    require "mixture/extensions/coercable"
    require "mixture/extensions/hashable"
    require "mixture/extensions/validatable"

    register :attribute, Attributable
    register :coerce, Coercable
    register :hash, Hashable
    register :validate, Validatable
  end
end
