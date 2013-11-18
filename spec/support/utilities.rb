include ApplicationHelper

#simulate the use interaction filling the fields
 def valid_edit(new_name, new_email, user)
   fill_in "Name",    with: new_name
   fill_in "Email",    with: new_email
   fill_in "Password", with: user.password
   fill_in "Confirm Password", with: user.password
   click_button "Save changes"
 end


 def valid_signin(user)
   fill_in "Email",    with: user.email
   fill_in "Password", with: user.password
   click_button "Sign in"
 end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end