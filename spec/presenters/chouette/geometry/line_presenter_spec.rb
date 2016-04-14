require 'spec_helper'

describe Chouette::Geometry::LinePresenter do
  let!(:line) { create(:line_with_stop_areas_having_parent) }
  subject { Chouette::Geometry::LinePresenter.new(line)}

  describe "#routes_localized_commercials" do
    it "should return 3 stop_areas" do
      expect(subject.routes_localized_commercials(line.routes.first).size).to eq(10)
    end
  end
end

