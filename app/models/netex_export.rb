class NetexExport < Export

  def export_options
    super.merge(:format => :netex)
  end

end
