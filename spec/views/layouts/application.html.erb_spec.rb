require 'spec_helper'

describe "/layouts/application" do

  before(:each) do
    view.stub :user_signed_in? => true
  end

  context "when Referential is a new record" do
     
    let(:referential) { Referential.new }

    it "should display referential name as title" #do
    #   render
    #   rendered.should_not have_selector("h1")
    # end
                                          
  end

end
