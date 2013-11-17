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
	$ rails generate integration_test authentication_pages
		Creates spec/requests/authentication_pages_spec.rb

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
		In app/controller/sessions_controller.rb
			sign_in user
      		redirect_to user
     Remember me
     	protect_from_forgery with: :exception
     	#The module to use session
  		include SessionsHelper

  		$ rails generate migration add_remember_token_to_users

  		In user_spec.rb
			it { should respond_to(:password_confirmation) }
  			it { should respond_to(:remember_token) }
			it { should respond_to(:authenticate) }
		In db/migrate/[ts]_add_remember_token_to_users.rb
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
			      flash[:success] = "Welcome to the Sample App!"
			      redirect_to @user
			    else
			      render 'new'
			    end
			end
	Siging out
		spec/requests/authentication_pages_spec.rb
			describe "followed by signout" do
		        before { click_link "Sign out" }
		        it { should have_link('Sign in') }
		    end
		in sessions_helper.rb
			  def sign_out
			    self.current_user = nil
			    cookies.delete(:remember_token)
			  end
	Using Cucumber - BDD test

		Addin cucumber-rails in GemFile
			gem 'cucumber-rails', '1.4.0', :require => false
  			gem 'database_cleaner', github: 'bmabey/database_cleaner'
		$ bundle install
		- Generate files for cucumber in features
			$ rails generate cucumber:install

		in features/signing_in.feature
			Create a feature
		$ bundle exec cucumber features/
			Will have errors
		Create features/step_definitions/authentication_steps.rb
		- Run test again
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
