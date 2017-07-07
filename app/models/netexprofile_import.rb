class NetexprofileImport < ImportTask

  attr_accessor :parse_site_frames, :validate_against_schema, :validate_against_profile

  def action_params
    {
      "netexprofile-import" => {
        "no_save" => no_save,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "parse_site_frames" => parse_site_frames.nil? ? false : @parse_site_frames,
        "validate_against_schema" => validate_against_schema.nil? ? true : @validate_against_schema,
        "validate_against_profile" => validate_against_profile.nil? ? true : @validate_against_profile
      }
    }
  end

  def data_format
    "netexprofile"
  end

end
