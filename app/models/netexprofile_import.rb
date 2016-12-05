class NetexprofileImport < ImportTask

  attr_accessor :valid_codespaces

  def action_params
    {
      "netexprofile-import" => {
        "no_save" => no_save,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "valid_codespaces" => valid_codespaces
      }
    }
  end

  def data_format
    "netexprofile"
  end

end
