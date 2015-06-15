require 'spec_helper'

describe ExportTask, :type => :model do

  it { should_not validate_presence_of(:start_date) }
  it { should_not validate_presence_of(:end_date) }

end
