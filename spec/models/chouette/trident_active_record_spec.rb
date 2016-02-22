require 'spec_helper'

describe Chouette::TridentActiveRecord, :type => :model do

  it { expect(Chouette::TridentActiveRecord.ancestors).to include(Chouette::ActiveRecord) }

  subject { create(:time_table) }

  describe "#uniq_objectid" do

    it "should rebuild objectid" do
      tm = create(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      expect(tm.objectid).to eq(subject.objectid+"_1")
    end

    it "should rebuild objectid" do
      tm = create(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      tm.save
      tm = create(:time_table)
      tm.objectid = subject.objectid
      tm.uniq_objectid
      expect(tm.objectid).to eq(subject.objectid+"_2")
    end

  end

  describe "#prepare_auto_columns" do

    it "should left objectid" do
      tm = Chouette::TimeTable.new :comment => "merge1" , :objectid => "NINOXE:Timetable:merge1"
      tm.prepare_auto_columns
      expect(tm.objectid).to eq("NINOXE:Timetable:merge1")
    end

    it "should add pending_id to objectid" do
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.prepare_auto_columns
      expect(tm.objectid.start_with?("NINOXE:Timetable:__pending_id__")).to be_truthy
    end

    it "should set id to objectid" do
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.save
      expect(tm.objectid).to eq("NINOXE:Timetable:"+tm.id.to_s)
    end

    it "should detect objectid conflicts" do
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.save
      tm.objectid = "NINOXE:Timetable:"+(tm.id+1).to_s
      tm.save
      tm = Chouette::TimeTable.new :comment => "merge1"
      tm.save
      expect(tm.objectid).to eq("NINOXE:Timetable:"+tm.id.to_s+"_1")
    end

  end

  describe "objectid" do

    it "should build automatic objectid when empty" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.save
      expect(g1.objectid).to eq("NINOXE:GroupOfLine:"+g1.id.to_s)
    end

    it "should build automatic objectid with fixed when only suffix given" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.objectid = "toto"
      g1.save
      expect(g1.objectid).to eq("NINOXE:GroupOfLine:toto")
    end
    
    it "should build automatic objectid with extension when already exists" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.save
      cnt = g1.id + 1
      g1.objectid = "NINOXE:GroupOfLine:"+cnt.to_s
      g1.save
      g2 = Chouette::GroupOfLine.new( :name => "g2")
      g2.save
      expect(g2.objectid).to eq("NINOXE:GroupOfLine:"+g2.id.to_s+"_1")
    end
    
    it "should build automatic objectid with extension when already exists" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.save
      cnt = g1.id + 2
      g1.objectid = "NINOXE:GroupOfLine:"+cnt.to_s
      g1.save
      g2 = Chouette::GroupOfLine.new( :name => "g2")
      g2.objectid = "NINOXE:GroupOfLine:"+cnt.to_s+"_1"
      g2.save
      g3 = Chouette::GroupOfLine.new( :name => "g3")
      g3.save
      expect(g3.objectid).to eq("NINOXE:GroupOfLine:"+g3.id.to_s+"_2")
    end
    
    it "should build automatic objectid when id cleared" do
      g1 = Chouette::GroupOfLine.new( :name => "g1")
      g1.objectid = "NINOXE:GroupOfLine:xxxx"
      g1.save
      g1.objectid = nil
      g1.save
      expect(g1.objectid).to eq("NINOXE:GroupOfLine:"+g1.id.to_s)
    end
  end

end


