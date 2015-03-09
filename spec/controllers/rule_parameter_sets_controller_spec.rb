require 'spec_helper'

describe RuleParameterSetsController, :type => :controller do
  login_user
  let(:mode){"air"}

  shared_examples_for "organisation dependant" do
    it "assigns rule_parameter_set.organisation as current organisation" do
      expect(assigns[:organisation]).to eq(organisation)
    end
  end

  describe "GET /index" do
    before(:each) do
      get :index
    end
    it "should assign rule_parameter_sets to organisation rule_parameter_sets" do
      assigns[:rule_parameter_sets].size.should == organisation.rule_parameter_sets.size
      assigns[:rule_parameter_sets].each do |rps|
        rps.organisation_id.should == organisation.id
      end
    end
  end

  describe "GET /new" do
    before(:each) do
      get :new
    end
    it_behaves_like "organisation dependant"
    it "should assign rule_parameter_set with default params" do
      RuleParameterSet.default_params.each do |k,v|
        expect(assigns[:rule_parameter_set].send( k )).to eq(v)
      end
    end
  end
end
