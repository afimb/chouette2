class CsvImport < ImportTask

  validates_presence_of :object_id_prefix
  option :object_id_prefix

end
