class HomeController < ApplicationController
  def index
    if signed_in?
    	@user = current_user
      @accounts  = current_user.accounts.to_a
      @current_account = current_user.current_account
#      @transactions = current_user.current_account.transactions.all
      if current_user.current_account.present?
       	@transactions = current_user.current_account.transactions.paginate(page: params[:page])
       end
      @transactions = Transaction.paginate(page: params[:page])
      redirect_to transactions_path
    end
  end

end
