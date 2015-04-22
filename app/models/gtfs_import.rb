class GtfsImport < ImportTask

  attr_accessor :object_id_prefix, :max_distance_for_commercial, :ignore_last_word,  :ignore_end_chars, :max_distance_for_connection_link
  
  validates_presence_of :object_id_prefix

  def references_types
    [ Chouette::StopArea ]
  end

end
