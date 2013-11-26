require 'spec_helper'

describe GroupCategory do
    before do
    	@group_category = GroupCategory.new(name: "Group 1", image: "image", group_type: "group_type")
	end

	subject { @group_category }   # for the variable group_category

	it { should respond_to(:name) }  # verify if these attributes exists
	it { should respond_to(:image) }
	it { should respond_to(:group_type) }

	it { should be_valid }
end
