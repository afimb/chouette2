require 'spec_helper'

describe Chouette::Company, :type => :model do

  subject { create(:company) }

  it { is_expected.to validate_presence_of :name }

  # it { should validate_presence_of :objectid }
  it { is_expected.to validate_uniqueness_of :objectid }

  describe "#nullables empty" do
    it "should set null empty nullable attributes" do
      subject.organizational_unit = ''
      subject.operating_department_name = ''
      subject.code = ''
      subject.phone = ''
      subject.fax = ''
      subject.email = ''
      subject.nil_if_blank
      expect(subject.organizational_unit).to be_nil
      expect(subject.operating_department_name).to be_nil
      expect(subject.code).to be_nil
      expect(subject.phone).to be_nil
      expect(subject.fax).to be_nil
      expect(subject.email).to be_nil
    end
  end

  describe "#nullables non empty" do
    it "should not set null non epmty nullable attributes" do
      subject.organizational_unit = 'a'
      subject.operating_department_name = 'b'
      subject.code = 'c'
      subject.phone = 'd'
      subject.fax = 'z'
      subject.email = 'r'
      subject.nil_if_blank
      expect(subject.organizational_unit).not_to be_nil
      expect(subject.operating_department_name).not_to be_nil
      expect(subject.code).not_to be_nil
      expect(subject.phone).not_to be_nil
      expect(subject.fax).not_to be_nil
      expect(subject.email).not_to be_nil
    end
  end

end
