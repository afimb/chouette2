require 'spec_helper'

describe ImportsController do
  login_user

  describe "GET 'new'" do
    it "returns http success" do
      pending
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'index'" do
    it "returns http success" do
      pending
      get 'index'
      response.should be_success
    end
  end

end
