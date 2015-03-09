require 'spec_helper'

describe CompaniesController do
  describe "routing" do
    it "not recognize #routes" do
      get( "/referentials/1/companies/2/routes").should_not route_to(
        :controller => "companies", :action => "routes",
        :referential_id => "1", :id => "2"
      )
    end
    it "not recognize #lines" do
      get( "/referentials/1/companies/2/lines").should_not route_to(
        :controller => "companies", :action => "lines",
        :referential_id => "1", :id => "2"
      )
    end
    it "recognize and generate #show" do
      get( "/referentials/1/companies/2").should route_to(
        :controller => "companies", :action => "show",
        :referential_id => "1", :id => "2"
      )
    end
  end
end

