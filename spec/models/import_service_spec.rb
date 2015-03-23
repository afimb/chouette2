require 'spec_helper'

describe ImportService, :type => :model do

  let(:referential) { create(:referential, :slug => "test") }
  
  subject { ImportService.new(referential) }

  describe '.find' do
    
    it "should build an import with a scheduled job" do
      import = subject.find(1)
    end

    it "should build an import with a terminated job" do
    end
    
  end
  
end
