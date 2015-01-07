module ReferentialHelper

  def first_referential
    Organisation.find_by_name("first").referentials.find_by_slug("first")
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      alias_method :referential, :first_referential
    end
  end

  module ClassMethods

    def assign_referential
      before(:each) do
        assign :referential, referential
      end
    end

  end

end

RSpec.configure do |config|
  config.include ReferentialHelper

  config.before(:suite) do
    # Truncating doesn't drop schemas, ensure we're clean here, first *may not* exist
    Apartment::Tenant.drop('first') rescue nil
    # Create the default tenant for our tests
    organisation = Organisation.where(:name => "first").first_or_create
    Referential.where(:prefix => "first", :name => "first", :slug => "first", :organisation => organisation).first_or_create
  end

  config.before(:each) do
    # Switch into the default tenant
    first_referential.switch
  end

  config.after(:each) do
    # Reset tenant back to `public`
    Apartment::Tenant.reset
  end 

end
