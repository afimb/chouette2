require 'spec_helper'

describe GtfsExport do

  its(:export_options) { should include(:format => :gtfs) }
  
end
