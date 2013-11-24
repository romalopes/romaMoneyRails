class AccountsController < ApplicationController
	before_action :signed_in_user

  def index
  	@accounts = current_user.accounts.paginate(page: params[:page])
  end
  def new
  	@account = Account.new
  end

  def create
    @account = current_user.accounts.build(account_params)

    oldAccount = current_user.accounts.find_by(name:@account.name)
    if oldAccount.present?
      flash[:error] = "Account #{@account.name} already exists."
      render 'new'
      return
    end

    if @account.save
      flash[:success] = "Account #{@account.name} created!"
      redirect_to root_url
      if current_user.current_account == nil
        current_user.update_attribute(:current_account_id, @account.id)
      end
    else
      render 'new'
    end
  end

  def edit
      @account = Account.find(params[:id])
    end

  def update
      @account = Account.find(params[:id])
      if @account.update_attributes(account_params)
        # Handle a successful update.
        flash[:success] = "Account updated"
        redirect_to accounts_path
      else
        render 'edit'
      end
  end

  def destroy
      account = Account.find(params[:id])
      account_id = account.id
      account.destroy

#      if current_user.current_account_id == account_id
        current_user.save_current_account_Id(Account.first.id)
 #     end
     
      flash[:success] = "Account deleted."
      redirect_to accounts_path
  end

  private 
  	    def account_params
	      params.require(:account).permit(:name, :description)
		end

end
