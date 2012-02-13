require 'spec_helper'

describe Referential do

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:slug) }

end