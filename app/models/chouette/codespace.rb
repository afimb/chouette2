class Chouette::Codespace < Chouette::ActiveRecord

  validates_presence_of :xmlns
  validates_presence_of :xmlnsurl

  validates :xmlns, :xmlnsurl, presence: true
  validates :xmlns, :xmlnsurl, uniqueness: true
  validates :xmlns, length: {maximum: 3}
  validates :xmlns, length: {minimum: 3}

  validates_format_of :xmlns, :with => %r{\A[A-Z]{3}\Z}, :allow_nil => false, :allow_blank => false
  validates_format_of :xmlnsurl, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => false, :allow_blank => false

end
