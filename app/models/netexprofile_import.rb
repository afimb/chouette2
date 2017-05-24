class NetexprofileImport < ImportTask

  attr_accessor :valid_codespaces, :parse_site_frames, :validate_against_schema, :validate_against_profile

  def action_params
    {
      "netexprofile-import" => {
        "no_save" => no_save,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "valid_codespaces" => valid_codespaces,
        "parse_site_frames" => parse_site_frames,
        "validate_against_schema" => validate_against_schema,
        "validate_against_profile" => validate_against_profile
      }
    }
  end

  def data_format
    "netexprofile"
  end

end
