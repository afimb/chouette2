require 'spec_helper'

describe Organisation do

  #it { should validate_presence_of(:name) }
  #it { should validate_uniqueness_of(:name) }

  it "create a rule_parameter_set" do
    organisation = create(:organisation)
    expect(organisation.rule_parameter_sets.size).to eq(1)
  end
end
