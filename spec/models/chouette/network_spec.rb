require 'spec_helper'

describe Chouette::Network, :type => :model do

  subject { create(:network) }

  it { is_expected.to validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { is_expected.to validate_uniqueness_of :objectid }

  describe "#stop_areas" do
    let!(:line){create(:line, :network => subject)}
    let!(:route){create(:route, :line => line)}
    it "should retrieve route's stop_areas" do
      expect(subject.stop_areas.count).to eq(route.stop_points.count)
    end
  end
end
