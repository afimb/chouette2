# require 'spec_helper'

# describe RuleParameterSet, :type => :model do

#   describe ".mode_of_mode_attribute" do
#     it "should retreive attribute name" do
#       expect(subject.class.attribute_of_mode_attribute("dummy1_mode_dummy2")).to eq("dummy1")
#     end
#     it "should retreive mode" do
#       expect(subject.class.mode_of_mode_attribute("dummy1_mode_dummy2")).to eq("dummy2")
#     end
#   end

#   RuleParameterSet.mode_attribute_prefixes.each do |prefix|
#     RuleParameterSet.all_modes.map do |mode|
#       "#{prefix}_mode_#{mode}".tap do |attribute|
#         describe "##{attribute}=" do
#           it "should store value on parameters hash" do
#             subject.send( "#{attribute}=".to_sym, 1234)
#             expect(subject.send( attribute.to_sym)).to eq(1234)
#             expect(subject.parameters["mode_#{mode}"][ prefix]).to eq(1234)
#           end
#         end
#         it { is_expected.to allow_mass_assignment_of attribute.to_sym}
#       end
#     end
#   end

#   RuleParameterSet.general_attributes.each do |attribute|
#     describe "##{attribute}=" do
#       it "should store value on parameters hash" do
#         subject.send( "#{attribute}=".to_sym, 1234)
#         expect(subject.send( attribute.to_sym)).to eq(1234)
#         expect(subject.parameters[ attribute]).to eq(1234)
#       end
#     end
#     it { is_expected.to allow_mass_assignment_of attribute.to_sym}
#   end

#   describe "#referential" do
#     it { is_expected.to validate_presence_of(:referential) }
#     it { is_expected.to allow_mass_assignment_of :referential_id }
#   end

#   describe "#name" do
#     it { is_expected.to validate_presence_of(:name) }
#     it { is_expected.to allow_mass_assignment_of :name }
#   end
# end
