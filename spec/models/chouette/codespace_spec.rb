require 'spec_helper'

describe Chouette::Codespace do

  subject { build(:codespace) }

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

end
