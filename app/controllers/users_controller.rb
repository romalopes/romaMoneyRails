class UsersController < ApplicationController
	before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy, :change_to_this]
  	before_action :correct_user,   only: [:edit, :update]
   	before_action :admin_user,     only: :destroy


	def index
    	#@users = User.all
    	@users = User.paginate(page: params[:page])
  	end

	def new
		@user = User.new
	end

	def show
		@user = User.find(params[:id])
	end

    def create
	    #@user = User.new(params[:user])    # Not the final implementation!
	    #Equivalent to
	    #@user = User.new(name: "Foo Bar", email: "foo@invalid", password: "foo", password_confirmation: "bar")
	    #The final implementation
	    @user = User.new(user_params)
	    if @user.save
	      # Handle a successful save.
	      sign_in @user
	      flash[:success] = "Welcome to Roma Money Rails!"
	      redirect_to @user
	    else
	      render 'new'
	    end
    end

	def edit
  		@user = User.find(params[:id])
  	end

	def update
	    @user = User.find(params[:id])
	    if @user.update_attributes(user_params)
	      # Handle a successful update.
	      flash[:success] = "Profile updated"
	      redirect_to @user
	    else
	      render 'edit'
	    end
	end

	def destroy
	    User.find(params[:id]).destroy
	    flash[:success] = "User deleted."
	    redirect_to users_url
	end

	def change_to_this
		puts "Parameters xxxxx #{params}"
		@viewed_user = User.find(params[:id])
		@user = @viewed_user
		@current_user = @viewed_user
		flash[:success] = "Changed to #{@user.email}"
	    redirect_to @user

	end

    private
	    def user_params
	      params.require(:user).permit(:name, :email, :password,
	                                   :password_confirmation)
		end

	    def correct_user
	      @user = User.find(params[:id])
	      redirect_to(root_url) unless current_user?(@user)
	    end

	     def admin_user
	      redirect_to(root_url) unless current_user.admin?
	    end

end
