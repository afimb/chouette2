require 'spec_helper'

describe CsvExport do

  its(:export_options) { should include(:format => :csv) }
  
end
