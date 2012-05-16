require 'spec_helper'

describe StopPointsController do
  login_user

  let!(:referential) { create(:referential).switch }
  let!(:route) { referential; Factory(:route) }
  let(:permutated_stop_point_ids) {
    old_stop_point_ids = route.stop_points.map(&:id)
    old_stop_point_ids.permutation.to_a.select { |permutated| permutated != old_stop_point_ids}.first
  }

  it { should be_kind_of(ChouetteController) }

  shared_examples_for "route, line and referential linked (stop_points)" do
    it "assigns route as @route" do
      assigns[:route].should == route
    end
    it "assigns route.line as @line" do
      assigns[:line].should == route.line
    end

    it "assigns referential as @referential" do
      assigns[:referential].should == referential
    end
  end

  describe "sort routing" do
    let(:path) { sort_referential_line_route_stop_points_path( referential, route.line, route)}
    it "routes /referential/:referentialid/line/:lineid/route/:routeid/stop_points/sort to stop_points#sort" do
      { :post => path }.should route_to(:controller => "stop_points", 
                                       :action => "sort",
                                       :referential_id => referential.id.to_s,
                                       :line_id => route.line_id.to_s,
                                       :route_id => route.id.to_s )
    end
  end

  describe "POST /sort" do
    before(:each) do
      post :sort, :line_id => route.line_id,
          :route_id => route.id,
          :referential_id => referential.id,
          :stop_point => permutated_stop_point_ids
    end
    it_behaves_like "route, line and referential linked (stop_points)"
  end

  describe "#sort" do
    it "should delegate to route.sort! with permutated_stop_point_ids" do
      controller.stub!(:route => route, :params => { :stop_point => permutated_stop_point_ids})
      controller.stub!(:respond_to => nil)
      route.should_receive(:reorder!).with(permutated_stop_point_ids)
      controller.sort
    end
  end
  describe "GET /index" do
    before(:each) do
      get :index, :line_id => route.line_id,
          :route_id => route.id,
          :referential_id => referential.id
    end
    it_behaves_like "route, line and referential linked (stop_points)"
  end
  describe "POST /create" do
    before(:each) do
      post :create, :line_id => route.line_id,
          :referential_id => referential.id,
          :route_id => route.id,
          :stop_point => Factory.attributes_for(:stop_point)

    end
    it_behaves_like "route, line and referential linked (stop_points)"
  end
end
