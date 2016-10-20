class SigExport < ExportTask

  enumerize :references_type, in: %w( network line company group_of_line )

  def action_params
    {
      "sig-export" => {
        "name" => name,
        "references_type" => references_type,
        "reference_ids" => reference_ids,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "start_date" => start_date,
        "end_date" => end_date,
        "valid_after_export" => valid_after_export
      }
    }
  end
  
  def data_format
    'sig'
  end

end
