require 'spec_helper'

describe Chouette::Loader, :type => :model do

  subject { Chouette::Loader.new("test") }

  before(:each) do
    allow(subject).to receive_messages :execute! => true
  end

  describe "#load_dump" do

  end

  describe "#import" do

    let(:chouette_command) { double :run! => true }

    before(:each) do
      allow(subject).to receive_messages :chouette_command => chouette_command
    end

    it "should use specified file in -inputFile option" do
      expect(chouette_command).to receive(:run!).with(hash_including(:input_file => File.expand_path('file')))
      subject.import "file"
    end
    
    it "should use specified format in -format option" do
      expect(chouette_command).to receive(:run!).with(hash_including(:format => 'DUMMY'))
      subject.import "file", :format => "dummy"
    end
    
  end

  describe "#create" do
    
    it "should quote schema name" do
      expect(subject).to receive(:execute!).with(/"test"/)
      subject.create
    end

  end

  describe "#drop" do

    it "should quote schema name" do
      expect(subject).to receive(:execute!).with(/"test"/)
      subject.drop
    end
    
  end

  describe "#backup" do

    let(:file) { "/dev/null" }

    it "should call pg_dump" do
      expect(subject).to receive(:execute!).with(/^pg_dump/)
      subject.backup file
    end

    it "should dump in specified file" do
      expect(subject).to receive(:execute!).with(/-f #{file}/)
      subject.backup file
    end
  end

end

