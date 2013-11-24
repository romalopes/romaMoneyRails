class TransactionsController < ApplicationController
  before_action :signed_in_user

  respond_to :html, :js

  def new
    @transaction = Transaction.new
  end

  def index
    if current_user != nil && current_user.current_account != nil
      @transactions = current_user.current_account.transactions.paginate(page: params[:page])
    end
  end

  def stats
    flash[:error] = nil
    flash[:success] = nil

  @transactions = Transaction.where("account_id = ?", current_user.current_account)


  income_data = Hash.new(0)
  expense_data = Hash.new(0)

  sum_income = 0
  sum_expense = 0

   @transactions.each do |t| 
      name = t.category.name
      if t.category.group_category_id == 1
        if(income_data.has_key?(name))
          value = income_data[name] + t.value.to_i
          income_data [name] =value.to_i
        else
          income_data [name] = t.value.to_i
        end
        sum_income += t.value
      else
        if(expense_data.has_key?(name))
          value = expense_data[name] + t.value.to_i
          expense_data [name] = value.to_i
        else
          expense_data [name] = t.value.to_i
        end
        sum_expense += t.value
      end
   end
  data_income = []
  income_data.keys.each do |k|
    percentage = (100*income_data[k]/sum_income).to_i
    data_income << [k, percentage]
  end

  data_expense = []
  expense_data.keys.each do |k|
    percentage = (100*expense_data[k]/sum_expense).to_i
    data_expense << [k, percentage]
  end

  @chart_income = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 0, 0, 0]} )
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=> data_income
      }
      f.series(series)
      f.options[:title][:text] = "Incomes"
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" , 
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end
    @chart_expense = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 0, 0, 0]} )
      series = {
               :type=> 'pie',
               :name=> 'Browser share',
               :data=> data_expense
      }
      f.series(series)
      f.options[:title][:text] = "Expenses"
      f.legend(:layout=> 'vertical',:style=> {:left=> 'auto', :bottom=> 'auto',:right=> '50px',:top=> '100px'}) 
      f.plot_options(:pie=>{
        :allowPointSelect=>true, 
        :cursor=>"pointer" , 
        :dataLabels=>{
          :enabled=>true,
          :color=>"black",
          :style=>{
            :font=>"13px Trebuchet MS, Verdana, sans-serif"
          }
        }
      })
    end

########################    
    render 'stats'
  end


  def createStandard
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
    else
      flash[:error] = "Transaction #{@transaction.name} could not be created!"
    end
    @transactions = current_user.current_account.transactions.paginate(page: params[:page])
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
    def transaction_params
      params.require(:transaction).permit(:name, :description, 
                                              :value, :date)
    end
end
