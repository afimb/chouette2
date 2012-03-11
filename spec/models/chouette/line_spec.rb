require 'spec_helper'

describe Chouette::Line do

  subject { Factory :line }

  it { should validate_presence_of :name }

  it { should validate_presence_of :objectid }

  it { should validate_numericality_of :version }

  it { should validate_uniqueness_of :registrationnumber }

end
