class Chouette::Branding < Chouette::TridentActiveRecord

  def self.nullable_attributes
    [:name, :description, :url, :image]
  end

end
