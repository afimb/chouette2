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

  def self.available_srids
    [
        [ "UTM zone 32N", "EPSG:32632" ],
        [ "UTM zone 33N", "EPSG:32633" ],
        [ "UTM zone 34N", "EPSG:32634" ],
        [ "UTM zone 35N", "EPSG:32635" ],
        [ "WGS 84 / Latlong", "EPSG:4326" ]
    ]
  end

  def self.available_versions
    [
        [ "1.1D", "R11D" ],
        [ "1.2", "R12" ],
        [ "1.2Novus", "R12N" ],
        [ "1.3A", "R13A" ]
    ]
  end
end
