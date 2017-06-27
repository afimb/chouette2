require 'spec_helper'

describe Chouette::DestinationDisplay do

  subject { build(:codespace) }
  let!(:codespace) { create(:codespace, :xmlns => "ABC", :xmlns_url => "https://www.mycodepace.com/ns/abc") }

  it { should validate_presence_of :xmlns }
  it { should validate_presence_of :xmlns_url }

  it { is_expected.to validate_presence_of :xmlns }
  it { is_expected.to validate_presence_of :xmlns_url }

  it { is_expected.to validate_uniqueness_of :xmlns }
  it { is_expected.to validate_uniqueness_of :xmlns_url }


  describe "#nullables empty" do
    it "should set null empty nullable attributes" do
      subject.created_at = ''
      subject.updated_at = ''
      expect(subject.created_at).to be_nil
      expect(subject.updated_at).to be_nil
    end
  end

  describe "#nullables empty 2" do
    it "should set null empty nullable attributes" do
      codespace.xmlns = 'ABC'
      codespace.xmlns_url = 'https://www.mycodepace.com/ns/abc'
      codespace.created_at = ''
      codespace.updated_at = ''
      expect(codespace.created_at).to be_nil
      expect(codespace.updated_at).to be_nil
    end
  end
end
