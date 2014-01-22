module TypeIdsModelsHelper

  def type_ids_model_references_type( type_ids_model_class, type)
    ReferencesTypeHelper.new( type_ids_model_class, type)
  end

  class ReferencesTypeHelper

    attr_accessor :type_ids_model_class, :type

    def initialize( type_ids_model_class, type)
      @type_ids_model_class, @type = type_ids_model_class, type
    end
    def model_class
      type_ids_model_class.to_s.underscore
    end
    def input_id
      "#{model_class}_reference_#{relation_name}_ids"
    end
    def input_class
      "#{model_class}_#{relation_name}_reference_ids"
    end
    def relation_name
      type_ids_model_class.references_relation(type)
    end
  end

  def type_ids_model_references_input( form, type_ids_model, model_class, type)
    cct_type_helper = type_ids_model_references_type( model_class, type)
    ReferencesInput.new form, type_ids_model, type, cct_type_helper
  end

  class ReferencesInput

    attr_accessor :form, :type_ids_model, :type, :type_helper
    def initialize(form, type_ids_model, type, type_helper)
      @form, @type_ids_model, @type, @type_helper = form, type_ids_model, type, type_helper
    end

    delegate :input_id, :input_class, :model_class, :to => :type_helper

    def current?
      type_ids_model.references_type == type
    end

    def references_map
      references.collect { |child| { :id => child.id, :name => child.name } }
    end

    def wrapper_html_options
      {
        :class => "#{model_class}_reference_ids",
        :id => "#{input_id}_input",
        :"data-type" => type,
        :style => ("display: none" unless current?)
      }
    end

    def input_html_options
      {
        :id => input_id,
        :class =>  input_class,
        :"data-pre" => ( references_map.to_json if current? ),
        :disabled => (true unless current?)
      }
    end

    def input
      form.input :reference_ids, :as => :text, :wrapper_html => wrapper_html_options, :input_html => input_html_options
    end

  end

end

