class NetexExport < ExportTask

  enumerize :references_type, in: %w( network line company groupofline )

  def action_params
    {     
      "netex-export" => {
        "name" => name,
        "references_type" => references_type,
        "reference_ids" => reference_ids,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
      }
    }
  end
  
  def data_format
    "netex"
  end

end
