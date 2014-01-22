class GtfsImport < ImportTask

  validates_presence_of :object_id_prefix
  option :object_id_prefix
  option :max_distance_for_commercial
  option :ignore_last_word
  option :ignore_end_chars
  option :max_distance_for_connection_link

end
