require 'spec_helper'

describe Referential do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }
  it { should validate_presence_of(:prefix) }
  it { should validate_presence_of(:time_zone) }
end

