require 'spec_helper'

describe Api::V1::NetworksController do

  context "organisation and referntial" do
    let!(:organisation) {Organisation.find_by_name("first") || create(:organisation, :name => "first")}
    let!(:referential) {Referential.find_by_name("first") || create(:referential, :organisation => organisation)}
    let!(:api_key) {Api::V1::ApiKey.create( organisation, referential)}
    let!(:network) {
      Apartment::Database.switch(referential.slug)
      referential.networks.first || create(:network)
    }

    def provide_authorization( api_key, format)
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials( api_key.token)
      request.accept = format
    end
    def json_xml_format?
      request.accept == "application/json" || request.accept == "application/xml"
    end

    let(:h) { { :index => (Proc.new { get :index }),
                :show => (Proc.new { get :show, :id => network.objectid })}}
    [:index, :show].each do |http_verb|

      describe "GET ##{http_verb}" do
        ["application/json","application/xml","application/html"].each do |format|
          context "when an invalid authorization is provided" do
            before :each do
              request.env['HTTP_AUTHORIZATION'] =  ActionController::HttpAuthentication::Token.encode_credentials("dummy")
              request.accept = format
              h[http_verb].call
            end
            it "should return HTTP 401" do
              response.response_code.should == 401
            end
          end
          context "when no authorization is provided" do
            before :each do
              request.env['HTTP_AUTHORIZATION'] = nil
              request.accept = format
              h[http_verb].call
            end
            it "should return HTTP 401" do
              response.response_code.should == 401
            end
          end
          context "when authorization provided and request.accept is #{format}," do
            before :each do
              provide_authorization(api_key, format)
              h[http_verb].call
            end

            it "should assign expected api_key" do
              assigns[:api_key].should eql(api_key) if json_xml_format?
            end
            it "should assign expected referential" do
              assigns[:referential].should == api_key.referential if json_xml_format?
            end

            it "should return #{(format == "application/json" || format == "application/xml") ? "success" : "failure"} response" do
              if json_xml_format?
                response.should be_success
              else
                response.should_not be_success
              end
            end
          end
        end
      end
    end

    describe "GET #show" do
      context "when authorization provided and request.accept is json" do
        before :each do
          provide_authorization(api_key, "application/json")
          get :show, :id => network.objectid
        end

        it "should assign expected network" do
          assigns[:network].should == network
        end
      end
    end
    describe "GET #index" do
      context "when authorization provided and request.accept is json" do
        before :each do
          provide_authorization(api_key, "application/json")
          get :index
        end

        it "should assign expected networks" do
          assigns[:networks].should == [network]
        end
      end
    end
  end
end
