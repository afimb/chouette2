require 'spec_helper'

describe Chouette::FileValidator, :type => :model do

  subject { Chouette::FileValidator.new("public") }

  before(:each) do
    allow(subject).to receive_messages :execute! => true
  end


  describe "#validate" do

    let(:chouette_command) { double :run! => true }

    before(:each) do
      allow(subject).to receive_messages :chouette_command => chouette_command
    end

    it "should use specified file in -inputFile option" do
      expect(chouette_command).to receive(:run!).with(hash_including(:input_file => File.expand_path('file')))
      subject.validate "file"
    end
        
  end

end

