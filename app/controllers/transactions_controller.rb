class TransactionsController < ApplicationController
  before_action :signed_in_user

  respond_to :html, :js

  def new
    @transaction = Transaction.new
  end

    def index
      @transactions = current_user.current_account.transactions.paginate(page: params[:page])
     #flash[:success] = "#{current_user.current_account.name}"
    end


  def createStandard
    puts "\n\n\n\nCreateStandard\n\n\n"
    @transaction = Transaction.new(transaction_params)
    @transaction.account = current_user.current_account

    category = Category.find(params[:category])
    if category == nil
      flash[:error] = "Category not set!"
      render 'new'
      return
    end
    @transaction.category = category

    if @transaction.save
      flash[:success] = "Transaction #{@transaction.name} created!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def create

    flash[:error] = nil
    flash[:success] = nil
    puts "\n\n\n\nCreate\n\n\n"
    @transaction = Transaction.new(transaction_params)
    @transaction.account = current_user.current_account
    category = Category.find(params[:category])
    if category == nil
        flash[:error] = "Category not set!"
        render 'new'
        return
    end
    @transactions = current_user.current_account.transactions.paginate(page: params[:page])
    
    @transaction.category = category

    if @transaction.save
      flash[:success] = "Transaction #{@transaction.name} created!"
    else
      flash[:error] = "Transaction #{@transaction.name} could not be created!"
  #      render 'new'
    end
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js 
       #     render :partial => "transaction_history", :object => @transactions
    end

  end


  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    
    category = Category.find(params[:category])
    if category == nil
      flash[:error] = "Category not set! #{params}\n\n =======transaction= #{transaction_params}  \n\n--------#{params[:category]}-----"
      render 'new'
      return
    end
    transaction_params = { "category" => category }
    if @transaction.update_attributes(transaction_params)

      # Handle a successful update.
      flash[:success] = "Transaction updated  #{transaction_params}"
      redirect_to root_url
    else
      render 'edit'
    end
  end

  def destroyStandard
      transaction = Transaction.find(params[:id])

      transaction.destroy
      flash[:success] = "Transaction deleted."
      redirect_to root_url
  end

  def destroy
      transaction = Transaction.find(params[:id])
      @transactions = current_user.current_account.transactions.paginate(page: params[:page])
      transaction.destroy
      flash[:success] = "Transaction deleted."
      respond_to do |format|
        format.html { redirect_to transactions_path }
        format.js
      end
  end

  private
      private 
        def transaction_params
          params.require(:transaction).permit(:name, :description, 
                                              :value, :date)
    end

end
