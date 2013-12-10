class UserMailer < ActionMailer::Base
   default from: "romalopes@yahoo.com.br"

	def welcome_email(user)
	    @user = user
	    @url  = 'https://romamoneyrails.herokuapp.com/sigin'
	    mail(to: 'romalopes@yahoo.com.br', subject: 'Welcome to Roma Money Rails')
	end
end
