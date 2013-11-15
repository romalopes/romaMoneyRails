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
	- in gemfile include
		gem 'less', '2.2.2' 

Sending to Heroku

	To make heroku work with Bootstrap
		
		1. In your config/enviroments/production.rb:
			config.cache_classes = true
			config.serve_static_assets = true
			config.assets.compile = true
			config.assets.digest = true
		2. In GemFile
			group :production do
			  gem 'rails_log_stdout',           github: 'heroku/rails_log_stdout'
			  gem 'rails3_serve_static_assets', github: 'heroku/rails3_serve_static_assets'
			end
	Sending
	

then do the whole git add ., git commit, git push heroku master.


Including users
 	Git
 		$ git checkout master
		$ git checkout -b including-users
		Generate the controler class and file for User
			$ rails generate controller Users new --no-test-framework
		Generate the model class and file for User
		$ rails generate model User name:string email:string
		- For Model User is singular, different from Controller where Users is plural.

