class CsvImport < Import

  validates_presence_of :objectid_prefix
  option :objectid_prefix

  def import_options
    super.merge(:format => :csv, :objectid_prefix => objectid_prefix)
  end

end
