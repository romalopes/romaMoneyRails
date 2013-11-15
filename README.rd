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

 Including users
 