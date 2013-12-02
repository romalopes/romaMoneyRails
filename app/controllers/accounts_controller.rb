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

#DOUBT 
    Account.transaction do
      if @account.save
        flash[:success] = "Account #{@account.name} created!"
        redirect_to root_url
        if current_user.current_account == nil
          current_user.update_attribute(:current_account_id, @account.id)
        end

        user_account = UserAccount.new(user_id:current_user.id, account_id: @account.id)

        if !user_account.save
          flash[:error] = "User_Account not created."
          render 'new'
          return
        end
      else
        render 'new'
      end
    end
  end

  def edit
      @account = Account.find(params[:id])
    end

  def update
      @account = Account.find_by(id: params[:id])
      if @account == nil
        flash[:error] = "Account deleted by other user"
        redirect_to accounts_path
        return
      end

      if @account.update_attributes(account_params)
        # Handle a successful update.
        flash[:success] = "Account updated"
        redirect_to accounts_path
      else
        render 'edit'
      end
  end

  def destroy
      account = Account.find_by(id: params[:id])

      if account == nil
        flash[:error] = "Account deleted by other user"
        redirect_to accounts_path
        return
      end

      account_id = account.id

      #if he is the manager try search for all users that have this account
      #try to chante the current_account_id
      #destroy the account
      if account.user_manager?(current_user)
        account.destroy
        users = User.where("current_account_id = ?", account_id)
        users.each do |user|
            if user.current_account_id == account_id
              user.set_first_account_possible
            end
        end
      else
      #else only destroy the relationship
        #flash["user_account"] = "user_id: #{user_account.user_id}   account_id: #{user_account.account_id}"
        userAccount = UserAccount.find_by(user_id: current_user.id, account_id: account_id)
        userAccount.destroy
      end
      if current_user.current_account_id == account_id
        current_user.set_first_account_possible
      end

      #only destroy if 
      #countUserAccount = UserAccount.where("account_id = ?", account_id, false).count
      #if(countUserAccount == 1)
      #  account.destroy
      #end
      if current_user.current_account_id == nil
        redirect_to root_url
        return
      end
      flash[:success] = "Account deleted."
      redirect_to accounts_path
  end

  def invite_user_to_account
      user_id = params[:user_id]
      email = params[:email]
      account_id = params[:account_id]

      invited_user = User.find_by(email: email)
      if invited_user.nil?
          flash[:error] = "user #{email} not found"
      else
        if invited_user.id == user_id
          flash[:error] = "You are invinting yourself"
        else
          user_account = UserAccount.find_by(user_id: invited_user.id, account_id: account_id)
          if user_account.nil?
            user_account = UserAccount.new(user_id: invited_user.id, account_id: account_id)
            if user_account.save

              flash[:success] = "User invited"
              if invited_user.current_account_id == nil
                invited_user.update_attribute("current_account_id", account_id)
              end
            else
              flash[:error] = "Problem inviting user #{email}"
            end
          else
              flash[:error] = "Relationship already exists"
          end
        end
      end

      redirect_to accounts_path
  end

  private 
  	    def account_params
	      params.require(:account).permit(:name, :user_id, :description)
		end

end
