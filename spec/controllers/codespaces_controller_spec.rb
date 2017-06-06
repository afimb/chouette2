require 'spec_helper'

describe CodespacesController, type: :controller do
  login_user

  describe "GET #index" do
    it "returns http success" do
      pending
      get 'index'
      expect(response).to be_success
    end
  end

end
