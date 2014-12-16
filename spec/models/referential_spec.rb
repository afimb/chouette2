require 'spec_helper'

describe Referential do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:prefix) }
  it { should validate_presence_of(:time_zone) }

  it "create a rule_parameter_set" do
    referential = Factory.create(:referential)
    referential.rule_parameter_sets.size.should == 1
  end
end

