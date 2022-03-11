require 'spec_helper'

describe TimeTablesController do
  describe "routing" do
    it "not recognize #routes" do
      expect(get( "/referentials/1/time_tables/2/routes")).not_to route_to(
        :controller => "time_tables", :action => "routes",
        :referential_id => "1", :id => "2"
      )
    end
    it "not recognize #lines" do
      expect(get( "/referentials/1/time_tables/2/lines")).not_to route_to(
        :controller => "time_tables", :action => "lines",
        :referential_id => "1", :id => "2"
      )
    end
    it "not recognize #time_table_periods" do
      expect(get( "/referentials/1/time_tables/2/time_table_periods")).not_to route_to(
        "time_table_periods#index",
        :referential_id => "1", :time_table_id => "2"
      )
    end
    it "recognize and generate #show" do
      expect(get( "/referentials/1/time_tables/2")).to route_to(
        :controller => "time_tables", :action => "show",
        :referential_id => "1", :id => "2"
      )
    end
  end
end

