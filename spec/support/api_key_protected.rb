shared_examples "api key protected controller" do

    let(:h) { { :index => (Proc.new { get :index, :referential_id => provided_referential.id }),
                :show => (Proc.new { get :show, :referential_id => provided_referential.id, :id => data.objectid })}}
    [:index, :show].each do |http_verb|

      describe "GET ##{http_verb}" do
        ["application/json","application/xml","application/html"].each do |format|
          context "when an invalid authorization is provided" do
            before :each do
              puts "when an invalid authorization is provided"
              config_formatted_request_with_dummy_authorization( format)
              h[http_verb].call
            end
            it "should return HTTP 401" do
              response.response_code.should == 401
            end
          end
          context "when no authorization is provided" do
            before :each do
              puts "when no authorization is provided"
              config_formatted_request_without_authorization( format)
              h[http_verb].call
            end
            it "should return HTTP 401" do
              response.response_code.should == 401
            end
          end
          context "when authorization provided and request.accept is #{format}," do
            before :each do
              puts "when authorization provided and request.accept is #{format},"
              config_formatted_request_with_authorization( format)
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
end
