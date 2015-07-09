# encoding: utf-8

module Mixture
  module Validate
    def self.register(name, validator)
      validations[name] = validator
    end

    def self.validations
      @_validations ||= {}
    end

    require "mixture/validate/base"
    require "mixture/validate/match"
    require "mixture/validate/presence"

    register :match, Match
    register :format, Match
    register :presence, Presence

    def self.validate(record, attribute, value)
      attribute.options[:validate].each do |k, v|
        validator = validations.fetch(k).new(v)
        validate_with(validator, record, attribute, value)
      end
    end

    def self.validate_with(validator, record, attribute, value)
      validator.validate(record, attribute, value)

    rescue ValidationError => e
      record.errors[attribute] << e
    end
  end
end
