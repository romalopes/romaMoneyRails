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





