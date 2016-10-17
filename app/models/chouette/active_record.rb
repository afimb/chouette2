#require "active_record"
require 'deep_cloneable'
module Chouette
  class ActiveRecord < ::ActiveRecord::Base

    self.abstract_class = true

    before_save :nil_if_blank

    # to be overrided to set nullable attrs when empty
    def self.nullable_attributes
      []
    end

    def nil_if_blank
      self.class.nullable_attributes.each { |attr| self[attr] = nil if self[attr].blank? }
    end


    def human_attribute_name(*args)
      self.class.human_attribute_name(*args)
    end

    # class << self
    #   alias_method :create_reflection_without_chouette_naming, :create_reflection

    #   def create_reflection(macro, name, options, active_record)
    #     options = 
    #       Reflection.new(macro, name, options, active_record).options_with_default

    #     create_reflection_without_chouette_naming(macro, name, options, active_record)
    #   end
    # end



    # class Reflection

    #   attr_reader :macro, :name, :options, :active_record

    #   def initialize(macro, name, options, active_record)
    #     @macro, @name, @options, @active_record = macro, name.to_s, options, active_record
    #   end

    #   def collection?
    #     macro == :has_many
    #   end

    #   def singular_name
    #     collection? ? name.singularize : name
    #   end

    #   def class_name
    #     "Chouette::#{singular_name.camelize}"
    #   end

    #   def options_with_default
    #     options.dup.tap do |options|
    #       options[:class_name] ||= class_name
    #     end
    #   end

    # end

  end
end
