require 'spec_helper'

describe Chouette::ActiveRecord, :type => :model do

  it { expect(Chouette::ActiveRecord.ancestors).to include(ActiveRecord::Base) }

  describe "table_name" do

    it "should return line for Chouette::Line" do
      expect(Chouette::Line.table_name).to eq("lines")
    end
    
    it "should return ptnetwork for Chouette::Network" do
      expect(Chouette::Network.table_name).to eq("networks")
    end

    it "should return timetable_date for Chouette::TimeTableDate" do
      expect(Chouette::TimeTableDate.table_name).to eq("time_table_dates")
    end

    it "should return timetable_period for Chouette::TimeTablePeriod" do
      expect(Chouette::TimeTablePeriod.table_name).to eq("time_table_periods")
    end

  end

  describe "method_missing" do
    
    it "should support method with additionnal underscores" do
      stop_area = Chouette::StopArea.new
      expect(stop_area.area_type).to eq(stop_area.area_type)
    end

  end


  describe "respond_to?" do
    
    it "should respond to method with additionnal underscores" do
      stop_area = Chouette::StopArea.new
      expect(stop_area.respond_to?(:area_type)).to be_truthy
    end

  end

#   describe "create_reflection" do

#     let(:macro) { :has_many }
#     let(:name) { :lines }
#     let(:options) { {} }
#     let(:active_record) { Chouette::Network }
    
#     let(:modified_options) { {:modified => true}  }

#     it "should invoke create_reflection_without_chouette_naming with modified options" do
#       allow(Chouette::ActiveRecord::Reflection).to receive_messages :new => double(:options_with_default => modified_options)
#       expect(Chouette::ActiveRecord).to receive(:create_reflection_without_chouette_naming).with macro, name, modified_options, active_record

#       Chouette::ActiveRecord.create_reflection macro, name, options, active_record
#     end

#   end

end

# describe Chouette::ActiveRecord::Reflection, :type => :model do

#   let(:macro) { :has_many }
#   let(:name) { :lines }
#   let(:options) { {} }
#   let(:active_record) { Chouette::Network }

#   subject { Chouette::ActiveRecord::Reflection.new macro, name, options, active_record }

#   describe "collection?" do

#     it "should be true when macro is has_many" do
#       allow(subject).to receive_messages :macro => :has_many
#       expect(subject).to be_collection
#     end

#     it "should be false when macro is belongs_to" do
#       allow(subject).to receive_messages :macro => :belong_to
#       expect(subject).not_to be_collection
#     end

#   end

#   describe "class_name" do
    
#     it "should be Chouette::Line when name is line" do
#       allow(subject).to receive_messages :name => "line"
#       expect(subject.class_name).to eq("Chouette::Line")
#     end

#     it "should be Chouette::Routes when name is routes and reflection is a collection" do
#       allow(subject).to receive_messages :name => "routes", :collection? => true
#       expect(subject.class_name).to eq("Chouette::Route")
#     end

#   end


#   describe "options" do
    
#     it "should define class_name if not" do
#       allow(subject).to receive_messages :options => {}, :class_name => "class_name"
#       expect(subject.options_with_default[:class_name]).to eq("class_name")
#     end

#     it "should not define class_name if presents" do
#       allow(subject).to receive_messages :options => {:class_name => "dummy"}
#       expect(subject.options_with_default[:class_name]).to eq("dummy")
#     end

#   end
  

# end


