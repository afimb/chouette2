class NeptuneExport < Export

  def export_options
    super.merge(:format => :neptune)
  end

end
