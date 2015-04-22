class CsvImport < ImportTask

  attr_accessor :object_id_prefix
  validates_presence_of :object_id_prefix
 
end
