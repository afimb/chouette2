class NetexprofileImport < ImportTask

  attr_accessor :profile_id

  validates_presence_of :profile_id

  def action_params
    {
      "netexprofile-import" => {
        "no_save" => no_save,
        "user_name" => user_name,
        "name" => name,
        "organisation_name" => organisation.name,
        "referential_name" => referential.name
      }
    }
  end

  def data_format
    "netexprofile"
  end

end
