class HomeController < ApplicationController
  def index
    if signed_in?
    	@user = current_user
      @accounts  = current_user.accounts.to_a
      @current_account = current_user.current_account
    end
  end
end
