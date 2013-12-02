require 'spec_helper'

describe UserAccount do

  	let(:user1) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user) }

    let!(:account1) { FactoryGirl.create(:account, user: user1) }
	let!(:account2) { FactoryGirl.create(:account, user: user1) }

	before do
	 	@user_account1 = user1.user_accounts.create!(account_id: account1.id)
	 	@user_account2 = user1.user_accounts.create!(account_id: account2.id)
	end

	subject { @user_account1 }

	it { should be_valid }

	it { should respond_to(:account_id) }
	it { should respond_to(:user_id) }

 	it "should have associated user_accounts" do
		user_accounts = user1.user_accounts.to_a
	    expect(user_accounts).not_to be_empty
	end


	describe "when account is not present" do
		before { @user_account1.account_id = nil }
	    it { should_not be_valid }
	end

	describe "when user is not present" do
	    before { @user_account1.user_id = nil }
	    it { should_not be_valid }
	end
end