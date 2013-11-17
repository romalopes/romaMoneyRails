require 'spec_helper'

# describe "AuthenticationPages" do
#   describe "GET /authentication_pages" do
#     it "works! (now write some real specs)" do
#       # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#       get authentication_pages_index_path
#       response.status.should be(200)
#     end
#   end
# end

describe "Authentication" do

  	subject { page }

	describe "signin page" do
	    before { visit signin_path }

	    it { should have_content('Sign in') }
	    it { should have_title('Sign in') }
  	end

	describe "signin" do
	    before { visit signin_path }

	    describe "with invalid information" do
	    
	      before { click_button "Sign in" }

	      it { should have_title('Sign in') }
	      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
	    end

	    # To guarantee that in case of error, in the next page the flash with error will not be repeated. see 8.1.5
	    describe "after visiting another page" do
	    	before { click_link "Home" }  #click in any page to test
				it { should_not have_selector('div.alert.alert-error') }
		end

	 	describe "with valid information" do
	      let(:user) { FactoryGirl.create(:user) }

	      # Method declared in spec//support/utilities.rb
	      #simulate the use interaction filling the fields
	      # before do
	      #   fill_in "Email",    with: user.email.upcase
	      #   fill_in "Password", with: user.password
	      #   click_button "Sign in"
	 	  # end
	      before { valid_signin(user) }

	      describe "followed by signout" do
	        before { click_link "Sign out" }
	        it { should have_link('Sign in') }
	      end

	      it { should have_title(user.name) }
#	      it { should have_link('Users',       href: users_path) }
#	      it { should have_link('Profile',     href: user_path(user)) }
#	      it { should have_link('Settings',    href: edit_user_path(user)) }
	      it { should have_link('Sign out',    href: signout_path) }
	      it { should_not have_link('Sign in', href: signin_path) }
	    end
  	end
end
