# -*- coding: utf-8 -*-
require 'spec_helper'

describe StopAreaCopy, :type => :model do
  
  subject { StopAreaCopy.new(:source_id => 1, :hierarchy => "child", :area_type => "Quay") }
  
  describe ".save" do

    it "should create a child for source" do
      source = Chouette::StopArea.new( :area_type => "CommercialStopPoint", :name => "test1" )
      source.save
      subject.source_id = source.id
      subject.hierarchy = "child"
      subject.area_type = "Quay"
      subject.save
      source.reload
      expect(source.children.length).to eq(1)
      expect(source.children[0].name).to eq("test1")
    end
    it "should create a parent for source" do
      source = Chouette::StopArea.new( :area_type => "CommercialStopPoint", :name => "test2" )
      source.save
      subject.source_id = source.id
      subject.hierarchy = "parent"
      subject.area_type = "StopPlace"
      subject.save
      source.reload
      expect(source.parent).not_to be_nil
      expect(source.parent.name).to eq('test2')
    end
        
  end

end
