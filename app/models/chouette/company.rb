class Chouette::Company < Chouette::TridentActiveRecord
  include CompanyRestrictions
  has_many :lines
  belongs_to :branding
  validates_format_of :registration_number, :with => %r{\A[0-9A-Za-z_-]+\Z}, :allow_nil => true, :allow_blank => true
  validates_presence_of :name
  validates_presence_of :organisation_type
  validates_format_of :url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => true, :allow_blank => true
  validates_format_of :public_url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => true, :allow_blank => true

  def self.nullable_attributes
    [:organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :url, :time_zone, :organisation_type, :legal_name, :public_phone, :public_email, :public_url]
  end

  def self.operators
    where(:organisation_type => 'Operator')
  end

  def self.authorities
    where(:organisation_type => 'Authority')
  end

end
