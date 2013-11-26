require 'spec_helper'

describe Transaction do
  	let(:category) { FactoryGirl.create(:category) }
  	let(:account) { FactoryGirl.create(:account) }
	before { @transaction = Transaction.new(name: "Transaction", description: "Description", date: Time.now,
											value: 50, category: category, account: account) }

  	subject { @transaction }

	it { should respond_to(:name) }
	it { should respond_to(:description) }
	its(:category) { should eq category }
	its(:account) { should eq account }	

	it { should be_valid }

	describe "when category_id is not present" do
    	before { @transaction.category_id = nil }
    	it { should_not be_valid }
	end
	describe "when account_id is not present" do
    	before { @transaction.account_id = nil }
    	it { should_not be_valid }
	end

end
