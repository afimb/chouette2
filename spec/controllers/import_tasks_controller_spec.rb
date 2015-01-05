require 'spec_helper'

describe ImportTasksController, :type => :controller do
  login_user
  shared_examples_for "referential dependant" do
    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end

  describe "GET /new" do
    before(:each) do
      get :new,
          :referential_id => referential.id
    end
    it_behaves_like "referential dependant"
    it "should assign import_task with NeptuneImport instance" do
      expect(assigns[:import_task].class).to eq(NeptuneImport)
    end
    it "should assign import_task with Neptune format" do
      expect(assigns[:import_task].format).to eq(ImportTask.new.format)
    end
    it "should assign import_task with refrential.id" do
      expect(assigns[:import_task].referential_id).to eq(referential.id)
    end
    it "should assign import_task with logged in user id" do
      expect(assigns[:import_task].user_id).to eq(referential.organisation.users.first.id)
    end
    it "should assign import_task with logged in user name" do
      expect(assigns[:import_task].user_name).to eq(referential.organisation.users.first.name)
    end
  end

end
