require 'spec_helper'

describe CodespacesController, type: :controller do
  login_user

  let!(:codespace) { create(:codespace, :xmlns => "ABC", :xmlns_url => "https://www.mycodepace.com/ns/abc") }

  it { is_expected.to be_kind_of(ChouetteController) }

  shared_examples_for "codespace and referential linked" do
    it "assigns codespace as @codespace" do
      expect(assigns[:codespace]).to eq(codespace)
    end

    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end

  describe "GET /index" do
    before(:each) do
      get :index, params: { :referential_id => referential.id }
    end

    it "assigns referential as @referential" do
      expect(assigns[:referential]).to eq(referential)
    end
  end

  describe "POST /create" do
    before(:each) do
      post :create, params: { :referential_id => referential.id, :codespace => { :xmlns => "IKO", :xmlns_url => "http://juuuuhuu.com/ns/kaa"} }
    end

    it "has set values" do
      expect(assigns[:codespace].xmlns).to eq("IKO")
      expect(assigns[:codespace].xmlns_url).to eq("http://juuuuhuu.com/ns/kaa")
    end
  end

  describe "GET /show" do
    before(:each) do
      get :show, params: { :id => codespace.id, :referential_id => referential.id }
    end

    it_behaves_like "codespace and referential linked"
  end
end
