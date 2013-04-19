require 'spec_helper'

describe NetexExport do

  its(:export_options) { should include(:format => :netex) }
  
end
