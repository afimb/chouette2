require 'spec_helper'

describe CompaniesController do
  describe "routing" do
    it "not recognize #routes" do
      expect(get( "/referentials/1/companies/2/routes")).not_to route_to(
        :controller => "companies", :action => "routes",
        :referential_id => "1", :id => "2"
      )
    end
    it "not recognize #lines" do
      expect(get( "/referentials/1/companies/2/lines")).not_to route_to(
        :controller => "companies", :action => "lines",
        :referential_id => "1", :id => "2"
      )
    end
    it "recognize and generate #show" do
      expect(get( "/referentials/1/companies/2")).to route_to(
        :controller => "companies", :action => "show",
        :referential_id => "1", :id => "2"
      )
    end
  end
end

