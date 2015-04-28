class NetexImport < ImportTask

  def action_params  
    { 
      "netex-import" => {
        "no_save" => false,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
      }
    }
  end
    
  def data_format
    "netex"
  end

end
