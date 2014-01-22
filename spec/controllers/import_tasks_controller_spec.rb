require 'spec_helper'

describe ImportTasksController do
  login_user
  shared_examples_for "referential dependant" do
    it "assigns referential as @referential" do
      assigns[:referential].should == referential
    end
  end

  describe "GET /new" do
    before(:each) do
      get :new,
          :referential_id => referential.id
    end
    it_behaves_like "referential dependant"
    it "should assign import_task with NeptuneImport instance" do
      assigns[:import_task].class.should == NeptuneImport
    end
    it "should assign import_task with Neptune format" do
      assigns[:import_task].format.should == ImportTask.new.format
    end
    it "should assign import_task with refrential.id" do
      assigns[:import_task].referential_id.should == referential.id
    end
    it "should assign import_task with logged in user id" do
      assigns[:import_task].user_id.should == referential.organisation.users.first.id
    end
    it "should assign import_task with logged in user name" do
      assigns[:import_task].user_name.should == referential.organisation.users.first.name
    end
  end

end
