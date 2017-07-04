class Chouette::Codespace < Chouette::ActiveRecord

  validates_presence_of :xmlns
  validates_presence_of :xmlns_url

  validates :xmlns, :xmlns_url, presence: true
  validates :xmlns, :xmlns_url, uniqueness: true
  validates :xmlns, length: {maximum: 3}
  validates :xmlns, length: {minimum: 3}

  validates_format_of :xmlns, :with => %r{\A[A-Z]{3}\Z}, :allow_nil => false, :allow_blank => false
  validates_format_of :xmlns_url, :with => %r{\Ahttps?:\/\/([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?\Z}, :allow_nil => false, :allow_blank => false

  before_validation :strip_whitespace

  def self.model_name
    ActiveModel::Name.new self, Chouette, self.name.demodulize
  end

  def strip_whitespace
    self.xmlns = self.xmlns.strip unless self.xmlns.nil?
    self.xmlns_url = self.xmlns_url.strip unless self.xmlns_url.nil?
  end
end
