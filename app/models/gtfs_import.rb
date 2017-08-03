class GtfsImport < ImportTask

  enumerize :references_type, in: %w( stop_area )

  attr_accessor :object_id_prefix, :max_distance_for_commercial, :ignore_last_word,  :ignore_end_chars, :max_distance_for_connection_link, :references_type, :parse_interchanges

  validates_presence_of :object_id_prefix

  def references_types
    self.references_type.values
  end

  def action_params
    {
      "gtfs-import" => {
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
        "parse_interchanges" => parse_interchanges
      }
    }
  end


  def data_format
    "gtfs"
  end

end
