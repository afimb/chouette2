class NeptuneExport < ExportTask

  attr_accessor :extensions, :export_type
  enumerize :references_type, in: %w( network line company group_of_line )
  
  def action_params
    {
      "neptune-export" => {
        "name" => name,
        "references_type" => references_type,
        "reference_ids" => reference_ids,
        "user_name" => user_name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "projection_type" => projection_type || "",
        "start_date" => start_date,
        "end_date" => end_date
      }
    }
  end

  def data_format
    "neptune"
  end

end
