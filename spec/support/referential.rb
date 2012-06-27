module ReferentialHelper

  def first_referential
    Referential.find_by_slug("first")
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
    Referential.find_or_create_by_slug FactoryGirl.attributes_for(:referential, :slug => "first")
    # FIXME in Rails 3.2 :
    # Referential.where(:slug => 'first').first_or_create(FactoryGirl.attributes_for(:referential))
  end

  config.before(:each) do
    first_referential.switch
  end

end
