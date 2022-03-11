require 'spec_helper'

describe ExportTask, :type => :model do

  it { is_expected.not_to validate_presence_of(:start_date) }
  it { is_expected.not_to validate_presence_of(:end_date) }

end
