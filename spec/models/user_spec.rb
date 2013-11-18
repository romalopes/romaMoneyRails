require 'spec_helper'


describe User do


  before do
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

	subject { @user }   # for the variable user

	it { should respond_to(:name) }  # verify if these attributes exists
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }

	it { should respond_to(:remember_token) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }

	it { should be_valid }
	it { should_not be_admin }  #because the default if false

	describe "with admin attribute set to 'true'" do
		before do
		  @user.save!
		  @user.toggle!(:admin)
		end

		it { should be_admin }
	end

	it "should respond to 'name'" do
			expect(@user).to respond_to(:name)
		end

	it { should be_valid }# <---- Verify if it has all attributes

	describe "when name is not present" do
	    before { @user.name = "" }
	    it { should_not be_valid }
	end
	describe "when email is not present" do
	    before { @user.email = "" }
	    it { should_not be_valid }
	end

	describe "when password is not present" do
		before do
		    @user = User.new(name: "Example User", email: "user@example.com",
		                     password: " ", password_confirmation: " ")
		end
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		  before { @user.password_confirmation = "mismatch" }
		  it { should_not be_valid }
	end

	describe "with a password that's too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do
		#Before the test save the user created previously
		before { @user.save }
		#user found_user is retrieved from DB
		let(:found_user) { User.find_by(email: @user.email) }

		describe "with valid password" do
			# It will authenticate found_user == @user.
			it { should eq found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			#It may return false
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it { should_not eq user_for_invalid_password }
			#It will NOT authenticate
			specify { expect(user_for_invalid_password).to be_false }
		end
	end

end

