# require 'spec_helper'

# describe ComplianceCheckResult, :type => :model do

#   subject { Factory( :compliance_check_result)}

#   describe "#indice" do
#     context "when 1-NEPTUNE-XML-1 result" do
#       before(:each) do
#         subject.rule_code = "1-NEPTUNE-XML-1"
#       end

#       describe '#indice' do
#         subject { super().indice }
#         it { is_expected.to eq(1) }
#       end
#     end
#     context "when 2-NETEX-AccessLink-2 result" do
#       before(:each) do
#         subject.rule_code = "2-NETEX-AccessLink-2"
#       end

#       describe '#indice' do
#         subject { super().indice }
#         it { is_expected.to eq(2) }
#       end
#     end
#   end

#   describe "#data_type" do
#     context "when 1-NEPTUNE-XML-1 result" do
#       before(:each) do
#         subject.rule_code = "1-NEPTUNE-XML-1"
#       end

#       describe '#data_type' do
#         subject { super().data_type }
#         it { is_expected.to eq("XML") }
#       end
#     end
#     context "when 2-NETEX-AccessLink-2 result" do
#       before(:each) do
#         subject.rule_code = "2-NETEX-AccessLink-2"
#       end

#       describe '#data_type' do
#         subject { super().data_type }
#         it { is_expected.to eq("AccessLink") }
#       end
#     end
#   end

#   describe "#format" do
#     context "when 1-NEPTUNE-XML-1 result" do
#       before(:each) do
#         subject.rule_code = "1-NEPTUNE-XML-1"
#       end

#       describe '#format' do
#         subject { super().format }
#         it { is_expected.to eq("NEPTUNE") }
#       end
#     end
#     context "when 2-NETEX-AccessLink-2 result" do
#       before(:each) do
#         subject.rule_code = "2-NETEX-AccessLink-2"
#       end

#       describe '#format' do
#         subject { super().format }
#         it { is_expected.to eq("NETEX") }
#       end
#     end
#   end

#   describe "#level" do
#     context "when 1-NEPTUNE-XML-1 result" do
#       before(:each) do
#         subject.rule_code = "1-NEPTUNE-XML-1"
#       end

#       describe '#level' do
#         subject { super().level }
#         it { is_expected.to eq(1) }
#       end
#     end
#     context "when 2-NEPTUNE-AccessLink-2 result" do
#       before(:each) do
#         subject.rule_code = "2-NEPTUNE-AccessLink-2"
#       end

#       describe '#level' do
#         subject { super().level }
#         it { is_expected.to eq(2) }
#       end
#     end
#   end

# end

