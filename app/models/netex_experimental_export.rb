class NetexExperimentalExport < ExportTask

  enumerize :references_type, in: %w( network line company group_of_line )

  def action_params
    {
      "netex_experimental-export" => {
        "name" => name,
        "references_type" => references_type,
        "reference_ids" => reference_ids,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "start_date" => start_date,
        "end_date" => end_date,
        "valid_after_export" => valid_after_export,
        "default_codespace" => referential.prefix,
        "default_format" => referential.data_format
      }
    }
  end

  def data_format
    "netex_experimental"
  end

end
