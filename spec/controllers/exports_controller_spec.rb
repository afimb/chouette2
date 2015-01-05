require 'spec_helper'

describe ExportsController, :type => :controller do
  login_user

  describe "GET 'new'" do
    it "returns http success" do
      pending
      get 'new'
      expect(response).to be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      pending
      get 'index'
      expect(response).to be_success
    end
  end

end
