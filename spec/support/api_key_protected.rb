shared_examples "api key protected controller" do

    let(:h) { { :index => (Proc.new { get :index }),
                :show => (Proc.new { get :show, :id => data.objectid })}}
    [:index, :show].each do |http_verb|

      describe "GET ##{http_verb}" do
        ["application/json","application/xml","application/html"].each do |format|
          context "when an invalid authorization is provided" do
            before :each do
              config_formatted_request_with_dummy_authorization( format)
              h[http_verb].call
            end
            it "should return HTTP 401" do
              expect(response.response_code).to eq(401)
            end
          end
          context "when no authorization is provided" do
            before :each do
              config_formatted_request_without_authorization( format)
              h[http_verb].call
            end
            it "should return HTTP 401" do
              expect(response.response_code).to eq(401)
            end
          end
          context "when authorization provided and request.accept is #{format}," do
            before :each do
              config_formatted_request_with_authorization( format)
            end

            it "should assign expected api_key" do
              if json_xml_format?
                h[http_verb].call
                expect(assigns[:api_key]).to eql(api_key)
              end
            end
            it "should assign expected referential" do
              if json_xml_format?
                h[http_verb].call
                expect(assigns[:referential]).to eq(api_key.referential)
              end
            end

            it "should return #{(format == "application/json" || format == "application/xml") ? "success" : "failure"} response" do
              if json_xml_format?
                h[http_verb].call
                expect(response).to be_success
              else
                expect {h[http_verb].call}.to raise_error(ActionController::UnknownFormat)
              end
            end
          end
        end
      end
    end
end
