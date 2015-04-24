class CsvExport < ExportTask

  enumerize :references_type, in: %w( all network line company groupofline )

  def action_params
    {
      "parameters" => {
        "kml-export" => {
          "name" => name,
          "references_type" => references_type,
          "user_name" => user_name,
          "organisation_name" => organisation.name,
          "referential_name" => referential.name         
        }
      }
    }
  end
  
  def data_format
    "csv"
  end

end
