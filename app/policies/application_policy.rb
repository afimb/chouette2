class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def read?
    @user.read?
  end

  def write?
    !@user.read?
  end
end
