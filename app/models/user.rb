class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :async, :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :email, :password, :current_password, :password_confirmation, :remember_me, :name, :organisation_attributes

  belongs_to :organisation

  accepts_nested_attributes_for :organisation

  validates :organisation, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates :name, :presence => true

  before_validation(:on => :create) do
    self.password ||= Devise.friendly_token.first(6)
    self.password_confirmation ||= self.password
  end

  after_destroy :check_destroy_organisation
  
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0,20]
      user.email = auth.info.email if auth.info.email.present?
      user.name = auth.info.name
      
      if ["facebook"].include?(auth.provider)
        user.save(:validate => false)
      else
        user.email = auth.info.email
        user.save
      end
    end
  end
  

  private

  # remove organisation and referentials if last user of it
  def check_destroy_organisation
    if organisation.users.empty?
      organisation.destroy
    end
  end

end
