class NeptuneImport < Import

  def import_options
    super.merge(:format => :neptune)
  end

end
