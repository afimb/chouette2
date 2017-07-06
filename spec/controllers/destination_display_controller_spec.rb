require 'spec_helper'

describe DestinationDisplaysController, type: :controller do
  login_user

  let!(:destination_display) { create(:destination_display, :front_text => "25 majorstua") }
  let!(:destination_display_via) { create(:destination_display, :front_text => "via") }

  it { is_expected.to be_kind_of(ChouetteController) }

  shared_examples_for "destination_display and referential linked" do
    it "assigns destination_display as @destination_display" do
      expect(assigns[:destination_display]).to eq(destination_display)
    end

    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end

  describe "GET /index" do
    before(:each) do
      get :index,
          :referential_id => referential.id
    end

    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end

  describe "POST /create" do
    before(:each) do
      post :create,
           :referential_id => referential.id,
           :destination_display => { :name => "IKO", :front_text => "http://juuuuhuu.com/ns/kaa"}
    end

    it "has set values" do
      expect(assigns[:destination_display].name).to eq("IKO")
      expect(assigns[:destination_display].front_text).to eq("http://juuuuhuu.com/ns/kaa")
    end
  end

  describe "POST /create with via" do
    before(:each) do
      post :create,
           :referential_id => referential.id,
           :destination_display => { :name => "name", :front_text => "front text",
            :destination_display_vias_attributes => { "0" => {:destination_display_id => "", :position => 0, :via_id => destination_display_via.id}}
           }
    end

    it "has set values" do
      expect(assigns[:destination_display].name).to eq("name")
      expect(assigns[:destination_display].front_text).to eq("front text")
      expect(assigns[:destination_display].vias).to eq([destination_display_via])
    end
  end

  describe "PUT /update" do
    before(:each) do
      put :update,
          :id => destination_display.id,
          :referential_id => referential.id,
          :destination_display => { :name => "no  name", :front_text => "new front text",
            :destination_display_vias_attributes => { "0" => {:destination_display_id => destination_display.id, :position => 0, :via_id => destination_display_via.id}}
          }
    end

    it "has set values" do
      expect(assigns[:destination_display].front_text).to eq("new front text")
      expect(assigns[:destination_display].vias).to eq([destination_display_via])
    end
  end

  describe "GET /show" do
    before(:each) do
      get :show, :id => destination_display.id,
          :referential_id => referential.id
    end

    it_behaves_like "destination_display and referential linked"
  end
end
