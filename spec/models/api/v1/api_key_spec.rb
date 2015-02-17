require 'spec_helper'

describe Api::V1::ApiKey, :type => :model do
  let!(:referential){create(:referential)}
  subject { Api::V1::ApiKey.create( :name => "test", :referential => referential)}

  it "test" do
    expect(subject).to be_valid
    expect(subject.referential).to eq(referential)

  end
end

