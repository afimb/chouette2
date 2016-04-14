require 'spec_helper'

describe Chouette::TransportMode, :type => :model do
  
  def mode(text_code = "test", numerical_code = nil)
    numerical_code ||= 1 if text_code == "test"
    Chouette::TransportMode.new(text_code, numerical_code)
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
      expect(mode("unknown").to_i).to eq(0)
    end

    it "should find text code from numerical code" do
      expect(mode(0)).to be_unknown
    end

    it "should accept another mode" do
      expect(Chouette::TransportMode.new(mode("test"))).to eq(mode("test"))
    end
    
  end

  describe "#public_transport?" do
    
    it "should return false for interchange" do
      expect(mode("interchange")).not_to be_public_transport
    end

    it "should return true for other modes" do
      expect(mode("unknown")).to be_public_transport
    end

  end

  describe ".all" do
    
    Chouette::TransportMode.definitions.each do |text_code, numerical_code|
      it "should include a TransportMode #{text_code}" do
        expect(Chouette::TransportMode.all).to include(Chouette::TransportMode.new(text_code))
      end
    end

  end

end
