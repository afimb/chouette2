require 'spec_helper'

describe Api::V1::ApiKey do
  let!(:referential){Factory(:referential)}
  subject { Api::V1::ApiKey.create( :name => "test", :referential => referential)}

  it "test" do
    subject.should be_valid
    subject.referential.should == referential

  end
end

