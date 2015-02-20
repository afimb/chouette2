module ReferentialHelper

  def first_referential
    first_organisation.referentials.find_by_slug("first")
  end
  def first_organisation
    Organisation.find_by_name("first")
  end

  def self.included(base)
    base.class_eval do
      extend ClassMethods
      alias_method :referential, :first_referential
      alias_method :organisation, :first_organisation
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


  end

end

RSpec.configure do |config|
  config.include ReferentialHelper

  config.before(:suite) do
    organisation = Organisation.find_or_create_by_name :name => "first"
    organisation.referentials.find_by_slug("first" ) ||
      Referential.create(:prefix => "first", :name => "first", :slug => "first", :organisation => organisation)
    # FIXME in Rails 3.2 :
    # Referential.where(:slug => 'first').first_or_create(FactoryGirl.attributes_for(:referential))
  end

  config.before(:each) do
    first_referential.switch
  end

end
