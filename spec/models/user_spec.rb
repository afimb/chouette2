require 'spec_helper'

describe User, :type => :model do
  #it { should validate_uniqueness_of :email }
  #it { should validate_presence_of :name }

  describe "#destroy" do
    let!(:organisation){create(:organisation)}
    let!(:user){create(:user, :organisation => organisation)}
    context "user's organisation contains many user" do
      let!(:other_user){create(:user, :organisation => organisation)}
      it "should destoy also user's organisation" do
        user.destroy
        expect(Organisation.where(:name => organisation.name).exists?).to be_truthy
        read_organisation = Organisation.where(:name => organisation.name).first
        expect(read_organisation.users.count).to eq(1)
        expect(read_organisation.users.first).to eq(other_user)
      end
    end
  end
end
