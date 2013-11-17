class SessionsController < ApplicationController

	protect_from_forgery with: :exception
	include SessionsHelper

	def new
	end

	def create
		#render 'new'
		user = User.find_by(email: params[:session][:email].downcase)
		if user && user.authenticate(params[:session][:password])
		    # Sign the user in and redirect to the user's show page.
		    sign_in user  #call method in sessions_controller.
			#redirect_to user #redirect to user
			#Instead of redirect_to user,  call the redirect back
      		redirect_back_or user
		else
		    # Create an error message and re-render the signin form.
		    #flash[:error] = 'Invalid email/password combination' # Not quite right!
		    #Now to avoid repetition in case of calling another page.
	  		flash.now[:error] = 'Invalid email/password combination'
	  		render 'new'				
		end
	end
	def destroy
    	sign_out
    	redirect_to root_url
  	end
end
