module ReferentialHelper

  def first_referential
    Referential.where(:slug => "ch_1").take!
  end

  def first_user
    User.first
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      alias_method :referential, :first_referential
      alias_method :user, :first_user
    end
  end

  module ClassMethods

    def assign_referential
      before(:each) do
        assign :referential, referential
      end
    end
    def assign_organisation
      before(:each) do
        assign :organisation, referential.organisation
      end
    end
    def assign_user
      before(:each) do
        user = FactoryGirl.create(:user)
        assign :user, user
      end
    end
  end

end

RSpec.configure do |config|
  config.include ReferentialHelper

  config.before(:suite) do
    # Clean all tables to start
    DatabaseCleaner.clean_with :truncation, except: %w[spatial_ref_sys]
    # Truncating doesn't drop schemas, ensure we're clean here, first *may not* exist
    Apartment::Tenant.drop('ch_1') rescue nil
    # Create the default tenant for our tests
    organisation = Organisation.create!(:name => "first")
    Referential.create!(:prefix => "first", :name => "first", :slug => "ch_1", :organisation => organisation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    # Switch into the default tenant
    first_referential.switch
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation, { except: %w[spatial_ref_sys] }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    # Reset tenant back to `public`
    Apartment::Tenant.reset
    # Rollback transaction
    DatabaseCleaner.clean
  end

end
