class GtfsImport < Import

  validates_presence_of :objectid_prefix
  option :objectid_prefix
  option :max_distance_for_commercial
  option :ignore_last_word
  option :ignore_end_chars
  option :max_distance_for_connection_link
  
  def import_options
    super.merge(:format => :gtfs, :objectid_prefix => objectid_prefix,
     :max_distance_for_commercial => max_distance_for_commercial,
     :ignore_last_word => ignore_last_word,
     :ignore_end_chars => ignore_end_chars,
     :max_distance_for_connection_link => max_distance_for_connection_link)
  end

end
