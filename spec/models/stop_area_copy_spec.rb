# -*- coding: utf-8 -*-
require 'spec_helper'

describe StopAreaCopy do
  
  subject { StopAreaCopy.new(:source_id => 1, :hierarchy => "child", :area_type => "Quay") }

  it { should validate_presence_of :source_id }
  it { should validate_presence_of :hierarchy }
  it { should validate_presence_of :area_type }
  
  
  describe ".save" do

    it "should create a child for source" do
      source = Chouette::StopArea.new( :area_type => "CommercialStopPoint", :name => "test1" )
      source.save
      subject.source_id = source.id
      subject.hierarchy = "child"
      subject.area_type = "Quay"
      subject.save
      source.reload
      source.children.length.should == 1
      source.children[0].name.should == "test1"
    end
    it "should create a parent for source" do
      source = Chouette::StopArea.new( :area_type => "CommercialStopPoint", :name => "test2" )
      source.save
      subject.source_id = source.id
      subject.hierarchy = "parent"
      subject.area_type = "StopPlace"
      subject.save
      source.reload
      source.parent.should_not be_nil
      source.parent.name.should == 'test2'
    end
        
  end

end
