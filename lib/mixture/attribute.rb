# encoding: utf-8

module Mixture
  # An attribute for a mixture object.
  class Attribute
    def initialize(name, **options)
      @name = name
      @options = options
    end
  end
end
