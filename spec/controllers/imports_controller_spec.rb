require 'spec_helper'

describe ImportsController do
  login_user

  describe "GET 'new'" do
    it "returns http success" do
      pending
      get 'new'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    before(:each) do
      post :create,
          :referential_id => referential.id,
          :import => { :resources => Rack::Test::UploadedFile.new( "spec/fixtures/neptune.zip", 'application/zip', false)}
    end

    it "assigns import.referential as @referential" do
      assigns[:import].referential.should == referential
    end

    it "assigns referential as @referential" do
      assigns[:referential].should == referential
    end
    it "shoud redirect to imports" do
      response.should redirect_to referential_imports_path(referential)
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      pending
      get 'index'
      response.should be_success
    end
  end

end
