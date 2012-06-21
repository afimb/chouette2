module ExportsHelper

  @@export_references_type = {}
  def export_references_type(type)
    @@export_references_type[type] ||= ReferencesTypeHelper.new(type)
  end

  class ReferencesTypeHelper
    
    attr_accessor :type

    def initialize(type)
      @type = type.to_s
    end

    def relation_name
      Export.references_relation(type)
    end

    def input_id
      "export_reference_#{relation_name}_ids"
    end

  end

  def export_references_input(form, export, type)
    ReferencesInput.new form, export, export_references_type(type)
  end

  class ReferencesInput

    attr_accessor :form, :export, :type_helper
    def initialize(form, export, type_helper)
      @form, @export, @type_helper = form, export, type_helper
    end

    delegate :input_id, :type, :to => :type_helper

    def current?
      export.references_type == type
    end

    def references_map
      references.collect { |child| { :id => child.id, :name => child.name } } 
    end

    def wrapper_html_options
      { 
        :class => "export_reference_ids", 
        :id => "#{input_id}_input", 
        :"data-type" => type, 
        :style => ("display: none" unless current?) 
      }
    end

    def input_html_options
      { 
        :id => input_id, 
        :"data-pre" => ( references_map.to_json if current? ),
        :disabled => (true unless current?)
      }
    end
    
    def input
      form.input :reference_ids, :as => :text, :wrapper_html => wrapper_html_options, :input_html => input_html_options
    end

  end

end
