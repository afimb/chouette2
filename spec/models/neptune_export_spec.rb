require 'spec_helper'

describe NeptuneExport do

  its(:export_options) { should include(:format => :neptune) }
  
end
