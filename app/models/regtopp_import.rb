class RegtoppImport < ImportTask

  enumerize :references_type, in: %w( stop_area )
  
  attr_accessor :object_id_prefix, :max_distance_for_commercial, :ignore_last_word,  :ignore_end_chars, :max_distance_for_connection_link, :references_type, :coordinate_projection, :version
  
  validates_presence_of :object_id_prefix, :coordinate_projection, :version

  def references_types
    self.references_type.values
  end

  def action_params  
    {
      "regtopp-import" => {
        "no_save" => no_save,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "object_id_prefix" => object_id_prefix,
        "max_distance_for_commercial" => max_distance_for_commercial,
        "ignore_last_word" => ignore_last_word,
        "ignore_end_chars" => ignore_end_chars,
        "max_distance_for_connection_link" => max_distance_for_connection_link,
        "references_type" => references_type,
        "coordinate_projection" => coordinate_projection,
        "version" => version            
      }
    }
  end
  

  def data_format
    "regtopp"
  end
end
