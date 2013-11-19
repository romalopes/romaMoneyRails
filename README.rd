romaMoneyRails
===============

Steps to the project

Create project with rails composer

Include spork and guard

Include hearder, footer and copywrite

Include information of debug in application.html.erb
	<%= debug(params) if Rails.env.development? %>

Include Title for each different page.
	- Create test for page in spec/requests/static_pages_spec.rb
	- Create test for helper in spec/helper/application_helper_spec.rb
	- in application_helper.rb
 		- Include method full_title_page in helpers/applicaton_helper.rb

Puting in Git
	$ git add .
	$ git commit -m "Initial commit"
	$ git remote add origin https://github.com/romalopes/APPLICATION_NAME.git
		origin is a name of a remote repository(or branch) to be pushed in master
	$ git remote -v  //To see if this remove repository was created
	git status
	$ git pull origin master  //Before push you should give a pull to ensure the your master is equals to origin

	$ git push -u origin master

Include icons and links to twitter and facebook
	- http://noizwaves.github.io/bootstrap-social-buttons/
	- http://fortawesome.github.io/Font-Awesome/
	- https://github.com/bokmann/font-awesome-rails
	-  $ gem install font-awesome-rails
Layout and Bootstrap
	In  config/application.rb
		require "active_record/railtie"
		require "action_controller/railtie"
		require "action_mailer/railtie"
		require "sprockets/railtie"
		# require "rails/test_unit/railtie"
	After i18I
    	include -> config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
Sending to Heroku

	- Change config/initializer/secret_token.rb
		 secret token used by Rails to encrypt session variables so that it is dynamically generated rather than hard-coded
			require 'securerandom'

			def secure_token
			  token_file = Rails.root.join('.secret')
			  if File.exist?(token_file)
			    # Use the existing token.
			    File.read(token_file).chomp
			  else
			    # Generate a new token and store it in token_file.
			    token = SecureRandom.hex(64)
			    File.write(token_file, token)
			    token
			  end
			end
			RomaMoneyRails::Application.config.secret_key_base = secure_token		 
	To make heroku work with Bootstrap
		
		1. In your config/enviroments/production.rb:
			config.cache_classes = true
			config.serve_static_assets = true
			config.assets.compile = true
			config.assets.digest = true
		2. In GemFile
			- Send gem 'sqlite3' to group:developement, test
			- And
			group :production do
			  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
			  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
			  gem 'pg', '0.15.1'
			  gem 'rails_12factor', '0.0.2'
			end
	Sending
		https://devcenter.heroku.com/articles/getting-started-with-ruby
		Heroku works with PostgresQL
			- add a the declarations in Gemfile to be like the following

		Before deploy to heroku
			$ bundle install --without production
			$ bundle update
			$ bundle install

		Basic Commands básicos:
			$ heroku create
			$ git push heroku master
			$ heroku run rake db:migrate
			$ heroku open
			Running in http://romamoneyrails.herokuapp.com
Include users
 	Git
 		$ git checkout master
		$ git checkout -b include-users
		- Generate the controler class and file for User
			$ rails generate controller Users new --no-test-framework
				create  app/controllers/users_controller.rb
			     route  get "users/new"
			    invoke  erb
			    create    app/views/users
			    create    app/views/users/new.html.erb
			    invoke  helper
			    create    app/helpers/users_helper.rb
			    invoke  assets
			    invoke    coffee
			    create      app/assets/javascripts/users.js.coffee
			    invoke    scss
			    create      app/assets/stylesheets/users.css.scss
	- Generate the- model class and file for User
		- For Model User is singular, different from Controller where Users is plural.
		$ rails generate model User name:string email:string
		    invoke  active_record
		    create    db/migrate/20131115082645_create_users.rb
		    create    app/models/user.rb
		    invoke    rspec
		    create      spec/models/user_spec.rb
		    invoke      factory_girl
		    create        spec/factories/users.rb
		- It creates the migrate xxx_create_users.rb
			This file is used to create tables for database.
			class CreateUsers < ActiveRecord::Migration
			  def change
			    create_table :users do |t|
			      t.string :name
			      t.string :email

			      t.timestamps
			    end
			  end
			end
		- Run the migration to DB
			$ bundle exec rake db:migrate
				Creates the file: db/development.sqlite3
			A DB tet is create in db/test.sqlite3, but if there is a problem, create a new DB test.
				$ bundle exec rake test:prepare 
		- Result
			 - class User in app/models/user.rb don't have attributes yet.
				class User < ActiveRecord::Base
				end
			- But DB is already created with name and email.
	- Create the integration test to test the inexisting URL
		$ rails generate integration_test user_pages
		  invoke  rspec
	      create    spec/requests/user_pages_spec.rb
	    - Include a test about signup
			require 'spec_helper'
			describe "User pages" do
			  subject { page }

			  describe "signup page" do
			    before { visit signup_path }

			    it { should have_content('Sign up') }
			    it { should have_title(full_title('Sign up')) }
			  end
			end
		- Run to fail
			$ bundle exec rspec spec/
	- In index.html.erb
		Include 
		<% if signed_in? %>
		<% else %>
		  <div class="center hero-unit">
		    <%= link_to "Sign up now!", signup_path, class: "btn btn-large btn-primary" %>
		  </div>
		<% end %>
	- In application_helper.rb  #just to show how it works, latter it will go to another file
		def signed_in?
			false
		end
	- in config/routes.rb, include
	  match '/signup',  to: 'users#new',            via: 'get'
	- app/views/users/new.html.erb
		<% provide(:title, 'Sign up') %>
		<h1>Sign up</h1>
- Validation
	Create a testS in spec/models/user.rb
	Test if the attributes exist
		describe User do
			before { @user = User.new(name: "Example User", email: "user@example.com") }
			subject { @user }   # for the variable user
			it { should respond_to(:name) }  # verify if these attributes exists
			it { should respond_to(:email) }

			OR
			it "should respond to 'name'" do
  				expect(@user).to respond_to(:name)
  			end

			it { should be_valid }  <---- Verify if it has all attributes

			describe "when name is not present" do
			    before { @user.name = "" }
			    it { should_not be_valid }
			end

		end
	- Define validation
		Verify if an attribute is present in app/models/user.rb
			before_save { self.email = email.downcase }
			validates :name, presence: true, length: { maximum: 50 }
			VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
			validates :email, presence:   true,
			                format:     { with: VALID_EMAIL_REGEX },
			                uniqueness: { case_sensitive: false }
			validates :password, length: { minimum: 6 }

			has_secure_password

		But to guarantee uniqueness Create an index for users.email.
			$ rails generate migration add_index_to_users_email			
			- And change db/migrate/xxxx_add_index...
				class AddIndexToUsersEmail < ActiveRecord::Migration
				  def change
				    add_index :users, :email, unique: true
				  end
				end
				$ bundle exec rake db:migrate
	User Authentication
		Method to retrieve the User based on email and password.
		Everythin depends on "has_secure_password"
		Two steps:
			1 - Find User based on email
				user = User.find_by(email: email)
			2 - Authenticate with a given password
				current_user = user.authenticate(password)
				- Or return the user object OR false
		Test
			describe "return value of authenticate method" do
				#Before the test sava the user created previously
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
					#specify is synonym of it. Just used to avoid repetition.
				end
			end		
			- "let" is similar to set a variable.
	Add Password and security
 		https://github.com/rails/rails/blob/master/activemodel/lib/active_model/secure_password.rb
 		Rails method called has_secure_password  (Rails 3.1)
 		- Include in gemFile
 			gem 'bcrypt-ruby', '3.1.2'
		$ bundle install

		- Generate migration
			$ rails generate migration add_password_digest_to_users password_digest:string
				invoke  active_record
			      create    db/migrate/20131115134838_add_password_digest_to_users.rb

				- add_password_digest_to_users can be any name, but the sufix "_to_users" refers to users table.
				- name and type of attribute I created(password_digest:string)
Sign Up
	Include Resources
		in config/routes.rb:
			resources :users
		- This adds the URL working /users/1 and all RESTs urls
	Create HTML app/views/users/show.html.erb
		
	In controller, creates the method show to return the User.
		class UsersController < ApplicationController

  		def show
    		@user = User.find(params[:id])
  		end
  		...
  	In gemfile . This include the possibility of bootstrap MOCK.
		  gem 'factory_girl_rails', '4.2.1'

	- Then create a file spec/factories.rb
	  	FactoryGirl.define do
		  factory :user do
		    name     "Andersno Lopes"
		    email    "romalopes@yahoo.com.br"
		    password "foobar"
		    password_confirmation "foobar"
		  end
		end
	And use in user_pages_spec.rb test:
		let(:user) { FactoryGirl.create(:user) } 

	  describe "profile page" do
	    let(:user) { FactoryGirl.create(:user) }
	    before { visit user_path(user) }

	    it { should have_content(user.name) }
	    it { should have_title(user.name) }
	  end
	To make test fast with password, goes to config/environment/test.rb and include
		# Speed up tests by lowering bcrypt's cost function.
  		ActiveModel::SecurePassword.min_cost = true

  	- create method to use gravatar in app/helpers/users_helper.rb
  		Globally recognized avatar ( Gravatar) - http://en.gravatar.com/
	To clean DataBase
			$ bundle exec rake db:reset
			$ bundle exec rake test:prepare
	Tests to sign up page in rspec/requests/user_pages_spec.rb
		describe "signup" do

		    before { visit signup_path }

		    let(:submit) { "Create my account" }

		    describe "with invalid information" do
		      it "should not create a user" do
		        expect { click_button submit }.not_to change(User, :count)
		      end
		    end

		    describe "with valid information" do
		      before do
		        fill_in "Name",         with: "Example User"
		        fill_in "Email",        with: "user@example.com"
		        fill_in "Password",     with: "foobar"
		        fill_in "Confirmation", with: "foobar"
		      end

		      it "should create a user" do
		        expect { click_button submit }.to change(User, :count).by(1)
		      end
		    end
		end
	And app/controllers/users_controller.rb
	class UsersController < ApplicationController
	  
		def new   
			@user = User.new
		end

	    def create
		    @user = User.new(params[:user])    # Not the final implementation!
		    #Equivalent to
		    #@user = User.new(name: "Foo Bar", email: "foo@invalid", password: "foo", password_confirmation: "bar")
		    #The final implementation
		    @user = User.new(user_params)
		    if @user.save
		      # Handle a successful save.
		      flash[:success] = "Welcome to the Sample App!"
		      redirect_to @user
		    else
		      render 'new'
		    end
	    end
	     private
		    def user_params
		      params.require(:user).permit(:name, :email, :password,
		                                   :password_confirmation)
		    end
		end
	SSL
		In config/environments/production.rb, include to SSL
		  # Force all access to the app over SSL, use Strict-Transport-Security,
		  # and use secure cookies.
		  config.force_ssl = true

		- Heroku provides a pratform to SSL.  To create a SSL for your domaing, many steps should be taking and you should by a SSL certificate.
			- http://devcenter.heroku.com/articles/ssl

	Commiting
		    $ git add .
			$ git commit -m "include-users"
			$ git checkout master
			$ git merge sign-up
		
	    More Commiting and Heroku
	    	$ git commit -a -m "Add SSL in production"
			$ git push heroku master
			- Migrate the DB to heroku
				$ heroku run rake db:migrate
			$ heroku open


Sign in, sign out
	$ git checkout -b sign-in-out		

	Sign in and Sign out are particular REST action in a Controller
	$ rails generate controller Sessions --no-test-framework
		Create controller, view, helper, js.coffee and scss
			invoke  erb
		      create    app/views/sessions
		      invoke  helper
		      create    app/helpers/sessions_helper.rb
		      invoke  assets
		      invoke    coffee
		      create      app/assets/javascripts/sessions.js.coffee
		      invoke    scss
		      create      app/assets/stylesheets/sessions.css.scss

	$ rails generate integration_test authentication_pages
		Creates spec/requests/authentication_pages_spec.rb
			invoke  rspec
		      create    spec/requests/authentication_pages_spec.rb
	Create a test in spec/requests/authentication_pages_spec.rb
		require 'spec_helper'

		describe "Authentication" do

		  subject { page }

		  describe "signin page" do
		    before { visit signin_path }

		    it { should have_content('Sign in') }
		    it { should have_title('Sign in') }
		  end
		end

	in config/routes.rb
		resources :sessions, only: [:new, :create, :destroy]

		match '/signin',  to: 'sessions#new',         via: 'get'
  		match '/signout', to: 'sessions#destroy',     via: 'delete'
  			Should be invokes using HTTP DELETE request

  		use $ rake routes --- to see the routes
  	in app/controllers/sessions_controller.rb, define the methods.
  		  protect_from_forgery with: :exception
  		  include SessionsHelper

  			def new
			end

			def create
				#render 'new'
				user = User.find_by(email: params[:session][:email].downcase)
				if user && user.authenticate(params[:session][:password])
				    # Sign the user in and redirect to the user's show page.
				    sign_in user  #call method
	      			redirect_to user #redirect to user

				else
				    # Create an error message and re-render the signin form.
				    #flash[:error] = 'Invalid email/password combination' # Not quite right!
				    #Now to avoid repetition in case of calling another page.
		      		flash.now[:error] = 'Invalid email/password combination'
		      		render 'new'				
				end
			end

			def destroy
			end
	in pp/views/sessions/new.html.erb, insert a code
		<% provide(:title, "Sign in") %>
		<h1>Sign in</h1>
		<div class="row">
		  <div class="span4 offset4">
		    <%= form_for(:session, url: sessions_path) do |f| %>

		      <%= f.label :email %>
		      <%= f.text_field :email %>

		      <%= f.label :password %>
		      <%= f.password_field :password %>

		      <%= f.submit "Sign in", class: "btn btn-large btn-primary" %>
		    <% end %>

		    <p>New user? <%= link_to "Sign up now!", signup_path %></p>
		  </div>
		</div>
	Create a test for Signin
		int spec/requests/authentication_pages_spec.rb
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
		  	end
		$ bundle exec rspec spec/requests/authentication_pages_spec.rb -e "signin with invalid information"
			- Still error
	Sigin
		In app/controller/sessions_controller.rb calls the methods
			sign_in user
      		redirect_to user
     Remember me
     	protect_from_forgery with: :exception
     	#The module to use session
  		include SessionsHelper

  		$ rails generate migration add_remember_token_to_users
		  invoke  active_record
    		create    db/migrate/20131117051539_add_remember_token_to_users.rb
  		In user_spec.rb
			it { should respond_to(:password_confirmation) }
  			it { should respond_to(:remember_token) }
			it { should respond_to(:authenticate) }
		In db/migrate/20131117051539_add_remember_token_to_users.rb
			class AddRememberTokenToUsers < ActiveRecord::Migration
			  def change
			    add_column :users, :remember_token, :string
			    add_index  :users, :remember_token
			  end
			end
		DB Migrate
			$ bundle exec rake db:migrate
			$ bundle exec rake test:prepare
		In user.rb
			def User.new_remember_token
			    SecureRandom.urlsafe_base64
			  end

			  def User.encrypt(token)
			    Digest::SHA1.hexdigest(token.to_s)
			  end

			  private

			    def create_remember_token
			      self.remember_token = User.encrypt(User.new_remember_token)
			    end
	Sign_in Method
		in app/helpers/sessions_helper.rb
		module SessionsHelper

		  def sign_in(user)
		    remember_token = User.new_remember_token
		    cookies.permanent[:remember_token] = remember_token
		    user.update_attribute(:remember_token, User.encrypt(remember_token))
		    self.current_user = user
		  end

		 def signed_in?
		    !current_user.nil?
		  end

		  def current_user=(user)
		    @current_user = user
		  end

		  def current_user
		    remember_token = User.encrypt(cookies[:remember_token])
		    @current_user ||= User.find_by(remember_token: remember_token)
		  end
		end
	Verify if is is signed in
		def signed_in?
			!current_user.nil?
		end
		change app/views/layouts/_header.html.erb
			Include: 
			<% if signed_in? %>
				<li><%= link_to "Sign out", signout_path, method: "delete" %></li>
				...
	        <% else %>
	        	<li><%= link_to "Sign in", signin_path %></li>
	       	<% end %>
	Sigin upon Signup
	    Create a new test in spec/requests/user_pages_spec.rb

			describe "after saving the user" do
	        before { click_button submit }
	        let(:user) { User.find_by(email: 'user@example.com') }

	        it { should have_link('Sign out') }
	        it { should have_title(user.name) }
	        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
	      end
	    Change create in users_controller to include the sign_in @user
	    	def create
			    @user = User.new(user_params)
			    if @user.save
			      sign_in @user
			      ...
	Siging out
		spec/requests/authentication_pages_spec.rb
		 	describe "with valid information" do
		      let(:user) { FactoryGirl.create(:user) }

			  # Method declared in spec//support/utilities.rb
	      	  #simulate the use interaction filling the fields
		      before { valid_signin(user) }

			  describe "followed by signout" do
		        before { click_link "Sign out" }
		        it { should have_link('Sign in') }
		      end

		      it { should have_title(user.name) }
		      it { should have_link('Users',       href: users_path) }
		      it { should have_link('Profile',     href: user_path(user)) }
		      it { should have_link('Settings',    href: edit_user_path(user)) }
		      it { should have_link('Sign out',    href: signout_path) }
		      it { should_not have_link('Sign in', href: signin_path) }
		    end
		  end
		in sessions_helper.rb
			  def sign_out
			    self.current_user = nil
			    cookies.delete(:remember_token)
			  end
		in controllers/application_controller.rb
			include SessionsHelper
	in spec/support/utilities.rb
		It is possible to create methods to be used in test.
		Ex:

			def valid_signin(user)
			  fill_in "Email",    with: user.email
			  fill_in "Password", with: user.password
			  click_button "Sign in"
			end
	- Git/Heroku
		$ git add .
		$ git commit -m "Finish sign in"
		$ git checkout master
		$ git merge sign-in-out		
		$ git push
		$ git push heroku
		$ heroku run rake db:migrate
Updating, showing, and deleting users
	$ git checkout -b updating-users
	Updating
		While anyone can sign up, only the current user can update
		Only authorized users edit and update
	New tests in spec/requests/user_pages_spec.rb
		  describe "edit" do
		    let(:user) { FactoryGirl.create(:user) }
		    before { visit edit_user_path(user) }

		    describe "page" do
		      it { should have_content("Update your profile") }
		      it { should have_title("Edit user") }
		      it { should have_link('change', href: 'http://gravatar.com/emails') }
		    end

		    describe "with invalid information" do
		      before { click_button "Save changes" }

		      it { should have_content('error') }
		    end
		  end
	Add a method in users_controller.rb
		def edit
      		@user = User.find(params[:id])
    	end
    create a file views/users/edit.html.erb
    change in _header.html.erb
       <%= link_to "Settings", edit_user_path(current_user) %>
    include method to update in users_controller.rb
	  def update
	    @user = User.find(params[:id])
	    if @user.update_attributes(user_params)
	      flash[:success] = "Profile updated"
	      redirect_to @user
	    else
	      render 'edit'
	    end
	  end	
	- Authorization	  
		1o. Requiring signed-in users
			create test in authentication_pages_spec.rb.
			Use path to request directy to /users/1
			If call edit_user_path, should go to sign in.
			describe "authorization" do

			    describe "for non-signed-in users" do
			      let(:user) { FactoryGirl.create(:user) }

			      describe "in the Users controller" do

			        describe "visiting the edit page" do
			          before { visit edit_user_path(user) }
			          it { should have_title('Sign in') }
			        end

			        describe "submitting to the update action" do
			          before { patch user_path(user) }
			          specify { expect(response).to redirect_to(signin_path) }
			        end
			      end
			    end
			end

		2o. In users_controller.rb
			class UsersController < ApplicationController
			  before_action :signed_in_user, only: [:edit, :update]

			In session_helper.rb
				# Before filters
			    def signed_in_user
			      redirect_to signin_url, notice: "Please sign in." unless signed_in?
			    end
	- Now Requiring the right user
		1o. Include a test in authentication_pages_spec.rb
		 	describe "as wrong user" do
		      let(:user) { FactoryGirl.create(:user) }
		      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
		      before { sign_in user, no_capybara: true }

		      describe "submitting a GET request to the Users#edit action" do
		        before { get edit_user_path(wrong_user) }
		        specify { expect(response.body).not_to match(full_title('Edit user')) }
		        specify { expect(response).to redirect_to(root_url) }
		      end

		      describe "submitting a PATCH request to the Users#update action" do
		        before { patch user_path(wrong_user) }
		        specify { expect(response).to redirect_to(root_url) }
		      end
		    end
		2o Include code in users_controllers.rb
			  before_action :correct_user,   only: [:edit, :update]

			  AND

			   def correct_user
			      @user = User.find(params[:id])
			      redirect_to(root_url) unless current_user?(@user)
  		       end
  		       - current_user is defined in sessions_helper.rb
					  def current_user?(user)
					    user == current_user
					  end
	Friendly forwarding
		- If I click in one link, but I am not logged in, system send me to sign in page and then send me back to old page
		1o Include a test in authentication_pages_spec.rb
			describe "when attempting to visit a protected page" do
		        before do
		          visit edit_user_path(user)
		          fill_in "Email",    with: user.email
		          fill_in "Password", with: user.password
		          click_button "Sign in"
		        end

		        describe "after signing in" do

		          it "should render the desired protected page" do
		            expect(page).to have_title('Edit user')
		          end
		        end
		    end
		2o In sessions_helper.rb, make store the location of the request and redirect later.
			Put the url in session and then redirect to this url.
		  def redirect_back_or(default)
		    redirect_to(session[:return_to] || default)
		    session.delete(:return_to)
		  end

		  def store_location
		    session[:return_to] = request.url if request.get?
		  end
		3o Add the store_location to signed_in_user in UsersController
		    def signed_in_user
		      unless signed_in?
		        store_location
		        redirect_to signin_url, notice: "Please sign in."
		      end
		    end
		4o Use the redirect_back_or in method create of SessionController
			sign_in user
      		redirect_back_or user
    Showing all users
    	1o include a test in authentication_pages_spec.rb
	    	describe "visiting the user index" do
	          before { visit users_path }
	          it { should have_title('Sign in') }
	        end
	        - users_path goes to index of users_controller
	    2o In UserController
	    	- Include index
	    		before_action :signed_in_user, only: [:index, :edit, :update]
	    	- Create method index
	    		def index
					@users = User.all
	    		end

	    3o In spec/requests/user_pages_spec.rb
	    	Include test for index.

		    	describe "index" do
				    before do
				      sign_in FactoryGirl.create(:user)
				      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
				      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
				      visit users_path
				    end

				    it { should have_title('All users') }
				    it { should have_content('All users') }

				    it "should list each user" do
				      User.all.each do |user|
				        expect(page).to have_selector('li', text: user.name)
				      end
				    end
				end
		4o Create app/views/users/index.html.erb
		5o Include CSS for users.
		6o Include test in authentication_pages_spec.rb
			it { should have_link('Users',       href: users_path) }
		7o Include in _header.html.erb
			<% if signed_in? %>
            <li><%= link_to "Users", users_path %></li>
    Sample Users (like bootstrap)
    	1. Include Faker in GemFile
    		gem 'faker', '1.1.2'
    	2. Populate data in lib/tasks/sample_data.rake

    	3. run bundle to populate db
    		$ bundle exec rake db:reset
			$ bundle exec rake db:populate
			$ bundle exec rake test:prepare
	Pagination
		Use https://github.com/mislav/will_paginate/wiki . There are many others
		1. Include in GemFile
			gem 'will_paginate', '3.0.4'
			gem 'bootstrap-will_paginate', '0.0.9'
		2. 
			- Test for a "div" with CSS class "pagination"
			- Veirfy that the correct users appear on the first page of results.
			2.1 Define a sequence for test in spec/factories.rb
				FactoryGirl.define do
				  factory :user do
				    sequence(:name)  { |n| "Person #{n}" }
				    sequence(:email) { |n| "person_#{n}@example.com"}
				    password "foobar"
				    password_confirmation "foobar"
				  end
				end
		3. Change test in spec/requests/user_pages_spec.rb
				describe "index" do
				    let(:user) { FactoryGirl.create(:user) }
				    before(:each) do
				      sign_in user
				      visit users_path
				    end

				    it { should have_title('All users') }
				    it { should have_content('All users') }

				    describe "pagination" do

				      before(:all) { 30.times { FactoryGirl.create(:user) } }
				      after(:all)  { User.delete_all }

				      it { should have_selector('div.pagination') }

				      it "should list each user" do
				        User.paginate(page: 1).each do |user|
				          expect(page).to have_selector('li', text: user.name)
				        end
				      end
				    end
				end
		4. Include pagination in app/views/users/index.html.erb
		5. Change the index method in users_controller.rb
		   @users = User.paginate(page: params[:page])
		6. A possible improvement in index.html.erb
			<ul class="users">
			  <% @users.each do |user| %>
			    <%= render user %>  <!-- Call view/users/_user.html.erb  -->
			  <% end %>
			</ul>  
			-OR 
			  <ul class="users">
			  		<%= render @users %>
			  </ul>
			Rails knows that @users is related the a iteraction in each user and should call _user.html.erb partial.
	Deleting Users
		Administrative users
			Using a boolean "admin" in user model to idenfify privileged users
			- admin? boolean method
			1. Include test in users_spec.rb
				it { should respond_to(:authenticate) }
				  it { should respond_to(:admin) }

				  it { should be_valid }
				  it { should_not be_admin }

				  describe "with admin attribute set to 'true'" do
				    before do
				      @user.save!
				      @user.toggle!(:admin)
				    end

				    it { should be_admin }
				end
				- toggle! switch a value between true and false.
			2. Include the attribute admin in User table
				$ rails generate migration add_admin_to_users admin:boolean
					 invoke  active_record
      					create    db/migrate/20131117074343_add_admin_to_users.rb
				- Generates this
					class AddAdminToUsers < ActiveRecord::Migration
					  def change
					    add_column :users, :admin, :boolean, default: false
					  end
					end
					- just include a attribute default to false.
			3. Migrate
				$ bundle exec rake db:migrate
				$ bundle exec rake test:prepare					
				user = User.find(101)
				>> user.admin?
				=> false
				>> user.toggle!(:admin)
				=> true
				>> user.admin?
			4. Reset db
				$ bundle exec rake db:reset
				$ bundle exec rake db:populate
				$ bundle exec rake test:prepare
		5. Include test in user_pages_spec.rb
			it { should have_link('delete', href: user_path(User.first)) }
			it "should be able to delete another user" do
			  expect do
			    click_link('delete', match: :first)
			  end.to change(User, :count).by(-1)
			end
			it { should_not have_link('delete', href: user_path(admin)) }
		6. Change app/views/users/_user.html.erb to allow only admin 
			<li>
			  <%= gravatar_for user, size: 52 %>
			  <%= link_to user.name, user %>
			  <% if current_user.admin? && !current_user?(user) %>
			    | <%= link_to "delete", user, method: :delete,
			                                  data: { confirm: "You sure?" } %>
			  <% end %>
			</li>
		7. In users_controller.rb
			def destroy
			    User.find(params[:id]).destroy
			    flash[:success] = "User deleted."
			    redirect_to users_url
			end
		8. Adding a test to avoid malicious delete
			describe "as non-admin user" do
		      let(:user) { FactoryGirl.create(:user) }
		      let(:non_admin) { FactoryGirl.create(:user) }

		      before { sign_in non_admin, no_capybara: true }

		      describe "submitting a DELETE request to the Users#destroy action" do
		        before { delete user_path(user) }
		        specify { expect(response).to redirect_to(root_url) }
		      end
		    end
		9. In app/controllers/users_controller.rb
			Set that only admin can destroy.
			 before_action :admin_user,     only: :destroy

			def admin_user
      			redirect_to(root_url) unless current_user.admin?
    		end
    Git
	    $ git add .
		$ git commit -m "Finish user edit, update, index, and destroy actions"
		$ git checkout master
		$ git merge updating-users
		$ git push heroku
		$ heroku pg:reset DATABASE
		$ heroku run rake db:migrate
		$ heroku run rake db:populate
		$ heroku restart
		$ heroku open

Include Acconts
	git checkout -b include-accounts
	- Generate first Model (Account)
		$ rails generate model Account name:string user_id:integer balance:double description:string
			 invoke  active_record
		      create    db/migrate/20131118040337_create_accounts.rb
		      create    app/models/account.rb
		      invoke    rspec
		      create      spec/models/account_spec.rb
		      invoke      factory_girl
		      create        spec/factories/accounts.rb
		- Add index to users
			class CreateAccounts < ActiveRecord::Migration
			  def change
			    create_table :accounts do |t|
			      t.string :name
			      t.integer :user_id
			      t.double :balance
			      t.string :description

			      t.timestamps
			    end
			    add_index :accounts, [:user_id, :created_at]
			  end
			end
		Migrate and Prepare to test
			$ bundle exec rake db:migrate	
			$ bundle exec rake test:prepare	
		- In app/models/account.rb
			class Account < ActiveRecord::Base
			  belongs_to :user
			  validates :user_id, presence: true
			  validates :name, presence: true, length: { minimum: 6, maximum: 50 }
			end

	In app/models/user.rb, include the has_many
		has_many :accounts, dependent: :destroy
	And in users_spec.rb
		it { should respond_to(:accounts) }

		AND

		describe "account associations" do
		    before { @user.save }
		    let!(:account1) do
		      FactoryGirl.create(:account, user: @user)
		    end
			let!(:account2) do
		      FactoryGirl.create(:account, user: @user)
		    end
		 	it "should destroy associated account" do
			      accounts = @user.accounts.to_a
			      @user.destroy
			      expect(accounts).not_to be_empty
			      accounts.each do |account|
			        expect(Account.where(id: account.id)).to be_empty
			      end
		    end
		end	

	In spec/factories.rb
		include the creation of account
			factory :account do
		    	name "Account1"
		    	description "First Account"
		    	balance 0.0
		    	user
		  	end
	In lib/tasks/sample_data, create the accounts
		def make_accounts
		    users = User.all
		    user  = users.first

		    #Create fake accounts
		    name = "account1"
		    description = "descriptin of account1"
		    user.accounts.create!(name: name,description: description)

		        name = "account2"
		    description = "descriptin of account2"
		    user.accounts.create!(name: name,description: description)
		end
	In home_controller.rb
		class HomeController < ApplicationController
		  def index
		    if signed_in?
		      @accounts  = current_user.accounts.to_a
		    end
		  end
		end
	In users_controller.rb
		def show
			@user = User.find(params[:id])
			@accounts  = @user.accounts.to_a
		end
	Add current Account to user
		$ rails generate migration add_current_account_id_to_users current_account_id:integer
			invoke  active_record
	      		create    db/migrate/20131118055435_add_current_account_id_to_users.rb
- Create Account
	$ rails generate controller Accounts new destroy --no-test-framework
		- Create a new account
		- list of accounts(manage account)
		- Change
		- Delete
		- Missing set current account
- Create Category and GroupCategory
	For while I will not implement any funtionality for management of Category.  They are created in sample_date.rake.
	- $ git checkout -b include-category
	1o Create GroupCategory
		$ rails generate model GroupCategory name:string image:string type:string
			invoke  active_record
		      create    db/migrate/20131118231020_create_group_categories.rb
		      create    app/models/group_category.rb
		      invoke    rspec
		      create      spec/models/group_category_spec.rb
		      invoke      factory_girl
		      create        spec/factories/group_categories.rb

	2o Create Category
		$ rails generate model Category name:string image:string group_category_id:integer
			invoke  active_record
		      create    db/migrate/20131118231030_create_categories.rb
		      create    app/models/category.rb
		      invoke    rspec
		      create      spec/models/category_spec.rb
		      invoke      factory_girl
		      create        spec/factories/categories.rb
	3o Include the associations and validations
		class GroupCategory < ActiveRecord::Base
			has_many :categories, dependent: :destroy

			validates :name, presence: true, length: { minimum: 2, maximum: 50 }
			validates :group_type, presence: true, length: { minimum: 2, maximum: 50 }
		end

		class Category < ActiveRecord::Base
			belongs_to :group_category

			validates :name, presence: true, length: { minimum: 2, maximum: 50 }
			validates :group_category_id, presence: true
		end

	4o
		$ bundle exec rake db:migrate
		$ bundle exec rake test:prepare 
	5o Include some groups and categories in sample_data.rake

    Git
	    $ git add .
		$ git commit -m "Include category and groupCategory"
		$ git checkout master
		$ git merge include-category
		$ git push heroku
		$ heroku pg:drop DATABASE
		$ heroku pg:reset DATABASE
		$ heroku run rake db:migrate
		$ heroku run rake db:populate
		$ heroku restart
		$ heroku open

- Create Transaction
