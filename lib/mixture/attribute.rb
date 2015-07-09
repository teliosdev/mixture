# encoding: utf-8

module Mixture
  # An attribute for a mixture object.
  class Attribute
    attr_reader :name
    attr_reader :options

    def initialize(name, list, options = {})
      @name = name
      @list = list
      @options = options
    end

    def update(value)
      @list.callbacks[:update].inject(value) { |a, e| e.call(self, a) }
    end

    def ivar
      @_ivar ||= :"@#{@name}"
    end

    def getter
      @name
    end

    def setter
      @_setter ||= :"#{@name}="
    end
  end
end
