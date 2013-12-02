require 'spec_helper'

describe "Account pages" do

  subject { page }

  #let(:user) { FactoryGirl.create(:user) }
  let(:user) { User.create(name: "Example User", email: "roma1@example.com",
                     password: "foobar", password_confirmation: "foobar") }


  before { sign_in user }

  describe "account creation" do
    before { visit root_path }


    let(:submit) { "Create a new account" }

    describe "should enter account creation page" do

      before { visit createAccount_path }

      it { should have_content('Create a new Account') }

      it { should have_selector('h1', text: "Create a new Account") }
      it { should have_title(full_title_page("Create Account")) }

      describe "with invalid information" do

        it "should not create an account" do
           expect { click_button submit }.not_to change(Account, :count)
         end

        describe "error messages" do
           before { click_button "Create a new account" }
           it { should have_content('Name can\'t be blank') }
           it { should have_content('Name is too short (minimum is 6 characters)') }
        end
      end

      describe "with valid information" do
        before do
          fill_in "Name",             with: "Account1"
          fill_in "Description",      with: "description"
        end
        it "should create a account" do
           expect { click_button submit }.to change(Account, :count)
        end
        describe "should click create a account " do
          before { click_button submit }
          it { should have_content('created!') }                 


          describe "should show account Content" do
            before { visit accounts_path }

            it { should have_content('All Accounts') }
            it { should have_content('Account1') }
            it { should have_content('this is the current account') }
            it { should have_link('Change', href: edit_account_path(1)) }
          end
        end
      end
    end
  end
  

  describe "manage account" do

     let(:user2) { User.create(name: "Example User", email: "roma@example.com",
                     password: "foobar", password_confirmation: "foobar") }

    let!(:account1) { FactoryGirl.create(:account, user: user) }
    let!(:accountA1) { Account.create(name: "AccountA1", user_id: user.id) }

    before do
      user_account1 = user.user_accounts.create!(account_id: account1.id)
      user_account2 = user.user_accounts.create!(account_id: accountA1.id)
      visit accounts_path
    end
     
    describe "should show account Content" do
      it { should have_content('All Accounts') }
      it { should have_content('AccountA') }
      #it { should have_content('this is the current account') }
      it { should have_link('delete', href: account_path(Account.first)) }
      it { should have_content('AccountA1') }


  #    it { should have_link('change', href: 'localhost:3000/accounts/1/edit') }

      describe "owner should remove the current account" do
        it "should be able to remove current account" do
          expect do
            click_link('delete', match: :first)
          end.to change(Account, :count).by(-1)
        end
      end

      describe "and owner remove another account" do

      end

      describe "should invite a user to account" do
      end
    end
    describe "should invited user manage account" do
      before do
        user_account3 = user2.user_accounts.create!(account_id: account1.id)
        sign_in user2 
        visit accounts_path
      end
      describe "should show account Content" do
        it { should have_content('All Accounts') }
        it { should have_content('AccountA') }
        it { should have_link('unassociate', href: account_path(Account.first)) }
      end

      describe "and invited user remove another account" do
        it "should be able to remove another account" do
          expect do
            click_link('unassociate', match: :first)
          end.to change(UserAccount, :count).by(-1)
        end 
      end
    end
  end



  #   describe "as correct user" do
       

  #      it "should delete a micropost" do
  #        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
  #      end
  #    end
  #  end  
end