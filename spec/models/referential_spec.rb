require 'spec_helper'

describe Referential, :type => :model do

  it "create a rule_parameter_set" do
    referential = create(:referential)
    #expect(referential.rule_parameter_sets.size).to eq(1)
  end
end
