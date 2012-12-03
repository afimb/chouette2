require 'spec_helper'


describe Api::V1::NetworksController do
  let!(:organisation) {Organisation.find_by_name("first") || create(:organisation, :name => "first")}
  let!(:referential) {Referential.find_by_name("first") || create(:referential, :organisation => organisation)}
  let!(:network) {referential.networks.where(:name => "first") || create(:network, :referential => referential)}

  context "no authorization provided" do
    it "should return HTTP 401" do
      get :index
      response.response_code.should == 401
    end
  end
  context "an invalid authorization is provided" do
    before(@each) do
      @request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("dummy")
    end
    it "should return HTTP 401" do
      get :index
      response.response_code.should == 401
    end
  end
  context "a valid authorization is provided" do
    let!(:api_key) {Api::V1::ApiKey.create( organisation, referential)}

    before(@each) do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials( api_key.token)
      request.accept = "application/json"
    end
    it "should assign expected api_key" do
      get :index
      assigns[:api_key].should eql(api_key) 
    end
    it "should assign expected referential" do
      get :index
      assigns[:referential].should == api_key.referential
    end
    it "should assign referntial's networks" do
      get :index
      assigns[:networks].should == api_key.referential.networks
    end
    context "the request format is HTML" do
      before(@each) do
        request.accept = "application/html"
      end
      it "should return HTTP 406" do
        get :index
        response.response_code.should == 406
      end
    end
    context "the request format is XML" do
      before(@each) do
        request.accept = "application/xml"
      end
      it "should return HTTP 200" do
        get :index
        response.response_code.should == 200
      end
    end
    context "the request format is JSON" do
      before(@each) do
        request.accept = "application/json"
      end
      it "should return HTTP 200" do
        get :index
        response.response_code.should == 200
      end
    end
  end
end
