class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :invitable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name

  belongs_to :organisation

  before_validation(:on => :create) do
    self.password ||= Devise.friendly_token.first(6)
  end
  
  # remove organisation and referentials if last user of it
  after_destroy :check_destroy_organisation
  def check_destroy_organisation
    if organisation.users.empty? 
      organisation.destroy
    end
  end

end
