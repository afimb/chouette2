class NetexImport < Import

  def import_options
    super.merge(:format => :netex)
  end

end
