require 'spec_helper'

describe Account do
	let(:user) { FactoryGirl.create(:user) }
	before { @account = user.account.build(name: "Account1", description: "First Account", balance:1000) }

  	subject { @account }

	it { should respond_to(:name) }
	it { should respond_to(:description) }
	it { should respond_to(:balance) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	its(:user) { should eq user }

	it { should be_valid }

	describe "when user_id is not present" do
    	before { @account.user_id = nil }
    	it { should_not be_valid }
	end
	
	describe "when user_id is not present" do
		before { @account.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank name" do
		before { @account.name = " " }
		it { should_not be_valid }
	end

	describe "with name that is too short" do
		before { @account.name = "a" * 5 }
		it { should_not be_valid }
	end
	
	describe "with name that is too long" do
		before { @account.long = "a" * 51 }
		it { should_not be_valid }
	end
end
