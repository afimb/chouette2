class GtfsExport < Export

  def export_options
    super.merge(:format => :gtfs)
  end

end
