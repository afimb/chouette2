require 'spec_helper'

describe NetworksController do
  describe "routing" do
    it "not recognize #routes" do
      expect(get( "/referentials/1/networks/2/routes")).not_to route_to(
        :controller => "networks", :action => "routes",
        :referential_id => "1", :id => "2"
      )
    end
    it "not recognize #lines" do
      expect(get( "/referentials/1/networks/2/lines")).not_to route_to(
        :controller => "networks", :action => "lines",
        :referential_id => "1", :id => "2"
      )
    end
    it "recognize and generate #show" do
      expect(get( "/referentials/1/networks/2")).to route_to(
        :controller => "networks", :action => "show",
        :referential_id => "1", :id => "2"
      )
    end
  end
end

