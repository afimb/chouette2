# require 'spec_helper'

# describe Chouette::ObjectId, :type => :model do

#   def objectid(value = "abc123")
#     Chouette::ObjectId.new value
#   end

#   subject { objectid }

#   context "when invalid" do
#     subject { objectid("ab c") }

#     it { is_expected.not_to be_valid }

#     describe '#parts' do
#       subject { super().parts }
#       it { is_expected.to be_nil }
#     end

#     describe '#system_id' do
#       subject { super().system_id }
#       it { is_expected.to be_nil }
#     end
#   end

#   context "when with spaces" do
#     subject { objectid("Aze toto") }
#     it { is_expected.not_to be_valid }
#   end

#   context "when valid" do
#     subject { objectid("Abc_19-Line-Abc_12") }
#     it { is_expected.to be_valid }
#   end

#   it "should be valid when parts are found" do
#     allow(subject).to receive_messages :parts => "dummy"
#     expect(subject).to be_valid
#   end

#   describe ".create" do
#     let(:given_system_id) { "systemId" }
#     let(:given_object_type) { "objectType" }
#     let(:given_local_id) { "localId" }

#     subject { Chouette::ObjectId.create(given_system_id, given_object_type, given_local_id) }

#     it "should return ObjectId attributes" do
#       expect(subject.send(:system_id)).to eq(given_system_id)
#       expect(subject.send(:object_type)).to eq(given_object_type)
#       expect(subject.send(:local_id)).to eq(given_local_id)
#     end

#   end

#   describe ".new" do

#     it "should return an existing ObjectId" do
#       expect(Chouette::ObjectId.new(objectid)).to eq(objectid)
#     end

#     it "should create an empty ObjectId with nil" do
#       expect(Chouette::ObjectId.new(nil)).to be_empty
#     end

#   end


# end
