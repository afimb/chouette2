require 'spec_helper'

describe RoutesController do
  login_user

  let!(:route) { Factory(:route) }

  it { should be_kind_of(ChouetteController) }

  shared_examples_for "redirected to referential_line_path(referential,line)" do
    it "should redirect_to referential_line_path(referential,line)" do
      response.should redirect_to( referential_line_path(referential,route.line) )
    end
  end
  shared_examples_for "line and referential linked" do
    it "assigns route.line as @line" do
      assigns[:line].should == route.line
    end

    it "assigns referential as @referential" do
      assigns[:referential].should == referential
    end
  end
  shared_examples_for "route, line and referential linked" do
    it "assigns route as @route" do
      assigns[:route].should == route
    end
    it_behaves_like "line and referential linked"
  end


  describe "GET /index" do
    before(:each) do
      get :index, :line_id => route.line_id,
          :referential_id => referential.id
    end

    it_behaves_like "line and referential linked"
    it_behaves_like "redirected to referential_line_path(referential,line)"

  end
  describe "POST /create" do
    before(:each) do
      post :create, :line_id => route.line_id,
          :referential_id => referential.id,
          :route => { :name => "changed"}

    end
    it_behaves_like "line and referential linked"
    it_behaves_like "redirected to referential_line_path(referential,line)"
  end
  describe "PUT /update" do
    before(:each) do
      put :update, :id => route.id, :line_id => route.line_id,
          :referential_id => referential.id
    end

    it_behaves_like "route, line and referential linked"
    it_behaves_like "redirected to referential_line_path(referential,line)"
  end
  describe "GET /show" do
    before(:each) do
      get :show, :id => route.id, 
          :line_id => route.line_id,
          :referential_id => referential.id
    end

    it_behaves_like "route, line and referential linked"

    it "assigns RouteMap.new( referential, route) as @map" do
      assigns[:map].should be_an_instance_of(RouteMap)
      assigns[:map].referential.should == referential
      assigns[:map].route.should == route
    end

    it "assigns route.stop_points.paginate(:page => nil, :per_page => 10) as @stop_points" do
      assigns[:stop_points].should == route.stop_points.paginate(:page => nil, :per_page => 10)
    end

  end
end

