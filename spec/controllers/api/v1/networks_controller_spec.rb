require 'spec_helper'


describe Api::V1::NetworksController do
  let!(:organisation) {Organisation.find_by_name("first") || create(:organisation, :name => "first")}
  let!(:referential) {Referential.find_by_name("first") || create(:referential, :organisation => organisation)}

  let!(:network) {referential.networks.where(:name => "first") || create(:network, :referential => referential)}

  def authorization_context(api_key)
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials( api_key.token)
    request.accept = "application/json"
  end
  shared_examples "authorization provided" do |format|
    before :each do
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials( api_key.token)
      request.accept = format
      action.call
    end

    def json_xml_format?
      request.accept == "application/json" || request.accept == "application/xml"
    end
    it "should assign expected api_key" do
      assigns[:api_key].should eql(api_key) if json_xml_format? 
    end
    it "should assign expected referential" do
      assigns[:referential].should == api_key.referential if json_xml_format?
    end
    it "should return HTTP 200 if json or xml format, HTTP 406 otherwise" do
      response.response_code.should == (json_xml_format? ? 200 : 406)
    end
  end
  shared_examples "authorization required" do
    before :each do
      action.call
    end
    context "when no authorization is provided" do
      it "should return HTTP 401" do
        request.env['HTTP_AUTHORIZATION'] = nil
        response.response_code.should == 401
      end
    end
    context "when an invalid authorization is provided" do
      it "should return HTTP 401" do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("dummy")
        response.response_code.should == 401
      end
    end
  end
  describe "show" do
    it_behaves_like "authorization required" do
      let(:action) { Proc.new { get :show, :id => network.id } }
    end
  end
  describe "index" do
    ["application/xml", "application/json", "application/html"].each do |format|
      it_behaves_like "authorization provided", format do
        let(:api_key) {Api::V1::ApiKey.create( organisation, referential)}
        let(:action) { Proc.new { get :index } }
      end
    end
    it_behaves_like "authorization required" do
      let(:action) { Proc.new { get :index } }
    end

    context "when authorization is valid" do
      let(:api_key) {Api::V1::ApiKey.create( organisation, referential)}
      before :each do
        authorization_context(api_key)
        get :index
      end
      it "should assigns networks with network" do
        assigns[:networks].should == referential.networks
      end
    end

  end
end
