require 'spec_helper'

describe Category do
  	let(:group_category) { FactoryGirl.create(:group_category) }
	before { @category = group_category.categories.build(name: "Category 1", description: "Description") }

  	subject { @category }

	it { should respond_to(:name) }
	it { should respond_to(:description) }
	its(:group_category) { should eq group_category }

	it { should be_valid }

	describe "when group_category_id is not present" do
    	before { @category.group_category_id = nil }
    	it { should_not be_valid }
	end
end
