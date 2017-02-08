require 'spec_helper'

describe Chouette::AreaType, :type => :model do

  def mode(text_code = "test", numerical_code = nil)
    numerical_code ||= 1 if text_code == "test"
    Chouette::AreaType.new(text_code, numerical_code)
  end

  describe "#to_i" do

    it "should return numerical code" do
      expect(mode("test", 1).to_i).to eq(1)
    end

  end

  it "should return true to #test? when text code is 'test'" do
    expect(mode("test")).to be_test
  end

  it "should be equal when text codes are identical" do
    expect(mode("test",1)).to eq(mode("test", 2))
  end

  describe ".new" do

    it "should find numerical code from text code" do
      expect(mode("boarding_position").to_i).to eq(0)
    end

    it "should find text code from numerical code" do
      expect(mode(0)).to eq("boarding_position")
    end

    it "should accept another mode" do
      expect(Chouette::AreaType.new(mode("test"))).to eq(mode("test"))
    end

  end


  describe ".all" do
    let!(:referential) { create(:referential) }
    Chouette::AreaType.all(:neptune).each do |text_code, numerical_code|
      it "should include a AreaType #{text_code}" do
        expect(Chouette::AreaType.all(:neptune)).to include(Chouette::AreaType.new(text_code))
      end
    end

  end

end
