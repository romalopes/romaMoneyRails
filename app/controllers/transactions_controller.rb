class TransactionsController < ApplicationController
  before_action :signed_in_user

  include ApplicationHelper
  respond_to :html, :js

  def new
    @transaction = new_transaction
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

    @result = Transaction.select("category_id, sum(value) as sum_value").group("category_id")

    data_income = []
    data_income_percentage = []
    data_expense = []
    data_expense_percentage = []

    sum_expense = 0
    sum_income = 0

    @result.each do |r|
      cat = Category.find(r.category_id)
      if(cat.group_category_id == 1)
        sum_income += r.sum_value;
      else
        sum_expense += r.sum_value;
      end
    end

    @result.each do |r|
      cat = Category.find(r.category_id)
      if(cat.group_category_id == 1)
        percentage = (100*r.sum_value/sum_income).to_i
        data_income_percentage << [cat.name, percentage]
        data_income <<  [cat.name, r.sum_value]
      else
        percentage = (100*r.sum_value/sum_expense).to_i
        data_expense_percentage << [cat.name, percentage]
        data_expense <<  [cat.name, r.sum_value]
      end
    end

    @chart_income = LazyHighCharts::HighChart.new('pie') do |f|
        f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 0, 0, 0]} )
        series = {
                 :type=> 'pie',
                 :name=> 'Incomes',
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
    @chart_income_percentage = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 0, 0, 0]} )
      series = {
               :type=> 'pie',
               :name=> 'Incomes Percentage',
               :data=> data_income_percentage
      }
      f.series(series)
      f.options[:title][:text] = "Incomes Percentage"
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
               :name=> 'Expenses',
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
    @chart_expense_percentage = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({:defaultSeriesType=>"pie" , :margin=> [50, 0, 0, 0]} )
      series = {
               :type=> 'pie',
               :name=> 'Expenses percentage',
               :data=> data_expense_percentage
      }
      f.series(series)
      f.options[:title][:text] = "Expenses percentage"
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
    render 'stats'
  end


  def createStandard
    @transaction = Transaction.new(transaction_params)
    @transaction.account = current_user.current_account

    categoryGroup_radio = params[:categoryGroup_radio]
    category = 0
    if categoryGroup_radio == nil
      flash[:error] = "Please, select a group of category."
      render 'new'
      return
    end
    if categoryGroup_radio == "income"
      category = params[:category_income]
    else categoryGroup_radio == "expense"
      category = params[:category_expense]
    end
  
    category = Category.find(category)
    @transaction.category = category

    if @transaction.save
      flash[:success] = "Transaction #{@transaction.name} created!"
      flash[:success] = "params=#{params}"
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

    categoryGroup_radio = params[:categoryGroup_radio]
    category = 0
    if categoryGroup_radio == nil
      flash[:error] = "Please, select a group of category."
    else
      if categoryGroup_radio == "income"
        category = params[:category_income]
      else categoryGroup_radio == "expense"
        category = params[:category_expense]
      end

      category = Category.find(category)

      @transaction.category = category

      if @transaction.save
        flash[:success] = "Transaction #{@transaction.name} created!"
      else
        flash[:error] = "Transaction #{@transaction.name} could not be created!"
      end
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
    
    if @transaction.category.group_category_id == 1
      @current_category_income = @transaction.category.id
    else
      @current_category_expense = @transaction.category.id
    end
  end

  def update
    @transaction = Transaction.find(params[:id])

    categoryGroup_radio = params[:categoryGroup_radio]
    category = 0
    if categoryGroup_radio == nil
      flash[:error] = "Please, select a group of category."
      render 'edit'
      return
    end

    if categoryGroup_radio == "income"
      category = params[:category_income]
    else
      category = params[:category_expense]
    end

    category = Category.find(category)
    if category == nil
        flash[:error] = "Category not set!"
        render 'edit'
        return
    end
    @transaction.category = category

    if(@transaction.invalid?)
      @transaction.errors.full_messages.each do |e|
        flash[e] = e
      end
      render 'edit'
      return

    end

    
    if @transaction.update_attributes(transaction_params)
      # Handle a successful update.
      flash[:success] = "Transaction updated."
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
      transaction.destroy
      @transactions = current_user.current_account.transactions.paginate(page: params[:page])

      # if @transactions.empty?
      #   redirect_to root_url
      # else
        flash[:success] = "Transaction deleted."
        respond_to do |format|
          format.html { redirect_to root_url }
          format.js
        end
      # end
  end

  private
    def transaction_params
      params.require(:transaction).permit(:name, :description, 
                                              :value, :date)
    end
end
