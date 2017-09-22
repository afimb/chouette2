class NetexprofileImport < ImportTask

  attr_accessor :object_id_prefix, :parse_site_frames, :validate_against_schema, :validate_against_profile, :continue_on_line_errors

  def action_params
    {
      "netexprofile-import" => {
        "no_save" => no_save,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name,
        "object_id_prefix" => object_id_prefix,
        "parse_site_frames" => parse_site_frames.nil? ? false : @parse_site_frames,
        "validate_against_schema" => validate_against_schema.nil? ? true : @validate_against_schema,
        "validate_against_profile" => validate_against_profile.nil? ? true : @validate_against_profile,
        "continue_on_line_errors" => continue_on_line_errors.nil? ? false : @continue_on_line_errors
      }
    }
  end

  def data_format
    "netexprofile"
  end

end
