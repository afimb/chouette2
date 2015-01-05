require 'spec_helper'

describe Api::V1::LinesController, :type => :controller do
  let!(:line) { referential.lines.first || create(:line) }

  it_behaves_like "api key protected controller" do
    let(:data){line}
  end
  describe "GET #index" do
    context "when authorization provided and request.accept is json" do
      before :each do
        config_formatted_request_with_authorization( "application/json")
        get :index
      end

      it "should assign expected lines" do
        expect(assigns[:lines]).to eq([line])
      end
    end
  end
end
