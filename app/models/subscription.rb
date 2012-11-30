class Subscription
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
 
  attr_accessor :organisation_name, :user_name, :email, :password, :password_confirmation
 
  validates_presence_of :organisation_name
  validates_presence_of :user_name
  validates_presence_of :email
  validates_presence_of :password
  validates_presence_of :password_confirmation

  def initialize(attributes = {})  
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end  
  end

  def persisted?  
    false  
  end  

  def user
    @user ||= organisation.users.build :name => user_name,:email => email, :password => password, :password_confirmation => password_confirmation
  end

  def organisation
    @organisation ||= Organisation.new :name => organisation_name
  end

  def valid?
    unless organisation.valid?
      self.errors.add( :organisation_name, organisation.errors[:name]) if organisation.errors[:name]
    end
    unless user.valid?
      self.errors.add( :user_name, user.errors[:name]) if user.errors[:name]
      self.errors.add( :password, user.errors[:password]) if user.errors[:password]
      self.errors.add( :email, user.errors[:email]) if user.errors[:email]
    end
    self.errors.empty?
  end

  def save
    if valid?
      organisation.save and user.save
    end
  end

end
