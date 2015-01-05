require 'spec_helper'

describe RoutesController, :type => :controller do
  login_user

  let!(:route) { Factory(:route) }

  it { is_expected.to be_kind_of(ChouetteController) }

  shared_examples_for "redirected to referential_line_path(referential,line)" do
    it "should redirect_to referential_line_path(referential,line)" do
      #response.should redirect_to( referential_line_path(referential,route.line) )
    end
  end
  shared_examples_for "line and referential linked" do
    it "assigns route.line as @line" do
      expect(assigns[:line]).to eq(route.line)
    end

    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end
  shared_examples_for "route, line and referential linked" do
    it "assigns route as @route" do
      expect(assigns[:route]).to eq(route)
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

    it "assigns RouteMap.new(route) as @map" do
      expect(assigns[:map]).to be_an_instance_of(RouteMap)
      expect(assigns[:map].route).to eq(route)
    end

    it "assigns route.stop_points.paginate(:page => nil) as @stop_points" do
      expect(assigns[:stop_points]).to eq(route.stop_points.paginate(:page => nil))
    end

  end
end

