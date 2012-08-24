require "spec_helper"

describe UserMailer do

  describe "welcome" do
    let(:user) {Factory(:user)}

    it "should verify if email send" do 
      email = UserMailer.welcome(user).deliver
      ActionMailer::Base.deliveries.empty?.should be_false
    end
    
    it "should verify the content of sending email" do
      email = UserMailer.welcome(user).deliver
      email.to.should == [user.email]
      email.subject.should == "Welcome to #{user.organisation.name}"
    end

  end

end
