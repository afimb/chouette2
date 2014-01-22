require 'spec_helper'

describe RuleParameterSetsController do
  login_user
  let(:mode){"air"}

  shared_examples_for "referential dependant" do
    it "assigns referential as @referential" do
      assigns[:referential].should == referential
    end
  end

  describe "GET /index" do
    before(:each) do
      get :index,
          :referential_id => referential.id
    end
    it_behaves_like "referential dependant"
  end

  describe "GET /new" do
    before(:each) do
      get :new,
          :referential_id => referential.id
    end
    it_behaves_like "referential dependant"
    it "should assign rule_parameter_set with default params" do
      RuleParameterSet.default_params.each do |k,v|
        assigns[:rule_parameter_set].send( k ).should == v
      end
      assigns[:rule_parameter_set].referential_id.should == referential.id
    end
  end
end
