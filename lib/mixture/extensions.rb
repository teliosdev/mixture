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
  end
end
