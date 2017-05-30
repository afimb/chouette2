require 'spec_helper'

describe Chouette::Codespace do

  subject { build(:codespace) }

  it { should validate_presence_of :xmlns }
  it { should validate_presence_of :xmlnsurl }

  it { is_expected.to validate_presence_of :xmlns }
  it { is_expected.to validate_presence_of :xmlnsurl }

  it { is_expected.to validate_uniqueness_of :xmlns }
  it { is_expected.to validate_uniqueness_of :xmlnsurl }

end
