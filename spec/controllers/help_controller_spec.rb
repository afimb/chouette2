require 'spec_helper'

describe HelpController do

  it "should render static files from app/views/help" do
    get "/"
  end

end
