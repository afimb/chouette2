require 'spec_helper'

describe User do
  #it { should validate_uniqueness_of :email }
  #it { should validate_presence_of :name }

  describe "#destroy" do
    let!(:organisation){Factory(:organisation)}
    let!(:user){Factory(:user, :organisation => organisation)}
    context "user's organisation contains many user" do
      let!(:other_user){Factory(:user, :organisation => organisation)}
      it "should destoy also user's organisation" do
        user.destroy
        Organisation.where(:name => organisation.name).exists?.should be_true
        read_organisation = Organisation.where(:name => organisation.name).first
        read_organisation.users.count.should == 1
        read_organisation.users.first.should == other_user
      end
    end
  end
end
