# encoding: utf-8

module Mixture
  # All of the extensions of mixture.  Handles registration of
  # extensions, so that extensions can be referend by a name instead
  # of the constant.
  module Extensions
    # Registers an extension with the module.  This maps a name to
    # an extension.  Extensions may be registered multiple times,
    # with different names.
    #
    # @param name [Symbol] The name of the extension to register.
    # @param extension [Module] The module to register.
    def self.register(name, extension)
      extensions[name.to_s.downcase.intern] = extension
    end

    # Loads an extension with the given name.  If it cannot find the
    # matching extension, it raises a `KeyError`.
    #
    # @param name [Symbol] The name of the extension.
    # @return [Module] The corresponding extension.
    # @raise [KeyError]
    def self.[](name)
      extensions.fetch(name)
    end

    # The extensions that are registered with this module.
    #
    # @return [Hash{Symbol => Module}]
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
