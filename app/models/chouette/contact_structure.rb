class Chouette::ContactStructure < Chouette::ActiveRecord

  def self.nullable_attributes
    [:contact_person, :email, :url, :fax, :phone, :further_details]
  end

end
