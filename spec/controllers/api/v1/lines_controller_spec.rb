require 'spec_helper'

describe Api::V1::LinesController do
    let!(:line) { referential.lines.first || create(:line) }

    it_behaves_like "api key protected controller" do
      let(:data){line}
      let(:provided_referential){referential}
    end
  describe "GET #index" do
    it "test" do
      puts referential.inspect
      puts "in spec api_key=#{api_key.inspect}"
    end
  end
end
