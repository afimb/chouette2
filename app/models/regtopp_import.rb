class RegtoppImport < ImportTask

  enumerize :references_type, in: %w( stop_area )

  attr_accessor :object_id_prefix, :references_type, :coordinate_projection, :version, :charset_encoding, :calendar_strategy, :batch_parse

  validates_presence_of :object_id_prefix, :coordinate_projection

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
        "references_type" => references_type,
        "coordinate_projection" => coordinate_projection,
        "version" => version,
        "charset_encoding" => charset_encoding,
        "calendar_strategy" => calendar_strategy
        "batch_parse" => batch_parse
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

  def self.charset_encoding
    [
        [ "CP865 / MS-DOS Nordic", "CP865" ],
        [ "ISO-8859-1 / Latin1", "ISO-8859-1" ]
    ]
  end

  def self.calendar_strategy
    [
        [ "Add using DKO-file start-date", "ADD" ],
        [ "Update/overwrite whole adminCode", "UPDATE" ]
    ]
  end
end
