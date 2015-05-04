class NeptuneImport < ImportTask
  
  def action_params  
    { 
      "neptune-import" => {
        "no_save" => false,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.slug,
      }
    }
  end
    
  def data_format
    "neptune"
  end

end
