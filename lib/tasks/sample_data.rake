namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_accounts
    make_group_categories
    make_categories
    make_transactions
  end
end

def make_users
    User.create!(name: "Anderson Lopes",
                 email: "romalopes@yahoo.com.br",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true,
                 current_account_id: 1)

    # User.create!(name: "Example User",
    #              email: "example@railstutorial.org",
    #              password: "foobar",
    #              password_confirmation: "foobar",
    #              admin: true)
    # 2.times do |n|
    #   name  = Faker::Name.name
    #   email = "example-#{n+1}@railstutorial.org"
    #   password  = "password"
    #   User.create!(name: name,
    #                email: email,
    #                password: password,
    #                password_confirmation: password)
    end
end

def make_accounts
    users = User.all
    user  = users.first

    #Create fake accounts
    name = "account1"
    description = "descriptin of account1"
    user.accounts.create!(name: name,description: description, balance:50.0)

    accounts = Account.all
    account = accounts.first
    #TODO se value from current_account_id
#    puts user.name
#    puts account.id
#    user.update_attributes(:current_account_id => account.id)

  
    user  = User.first
    puts "#{user.name}   #{user.current_account_id}.. #{account.balance}"

    name = "account2"
    description = "descriptin of account2"
    user.accounts.create!(name: name,description: description, balance:10)

    name = "account3"
    description = "descriptin of account3"
    user.accounts.create!(name: name,description: description, balance:-20)

end

def make_group_categories

  GroupCategory.create!(name: "Income",
                 image: "groupCategory/groupCategory.png",
                 group_type: "positive")

  GroupCategory.create!(name: "Expense",
                 image: "groupCategory/groupCategory.png",
                 group_type: "negative")
end

def make_categories
  groupCategories = GroupCategory.all
  income = groupCategories[0]
  puts income.name
  income.categories.create!(name: "Award",description: "", image:"category/category.png")
  income.categories.create!(name: "Salary",description: "", image:"category/category.png")
  income.categories.create!(name: "Selling",description: "", image:"category/category.png")
  income.categories.create!(name: "Donation",description: "", image:"category/category.png")
  income.categories.create!(name: "Others",description: "", image:"category/category.png")

  expense = groupCategories[1]
  puts expense.name
  expense.categories.create!(name: "Clothing",description: "", image:"category/category.png")
  expense.categories.create!(name: "Entertainment",description: "", image:"category/category.png")
  expense.categories.create!(name: "Family",description: "", image:"category/category.png")
  expense.categories.create!(name: "Food",description: "", image:"category/category.png")
  expense.categories.create!(name: "House",description: "", image:"category/category.png")
  expense.categories.create!(name: "Medical",description: "", image:"category/category.png")
  expense.categories.create!(name: "Shopping",description: "", image:"category/category.png")
  expense.categories.create!(name: "Study",description: "", image:"category/category.png")
  expense.categories.create!(name: "Transport",description: "", image:"category/category.png")
  expense.categories.create!(name: "Travel",description: "", image:"category/category.png")
  expense.categories.create!(name: "Others",description: "", image:"category/category.png")  
end

def make_transactions
  study_category = Category.find_by(name:"Study")
  transport_category = Category.find_by(name:"Transport")
  salary_category = Category.find_by(name:"Salary")

  user  = User.first
  account = user.accounts.find_by(name:"account1")

  Transaction.create!(name:"Transaction Salary",
                      value: 20,
                      date: Date.parse(Time.now.to_s),
                      category:salary_category,
                      account:account)

  Transaction.create!(name:"Transaction Study",
                      value: 10,
                      date: Date.parse(Time.now.to_s),
                      category:study_category,
                      account:account)

  Transaction.create!(name:"Transaction Transport",
                      value: 20,
                      date: Date.parse(Time.now.to_s),
                      category:study_category,
                      account:account)

      #   t.string :name
      # t.references :castegory, index: true
      # t.references :account, index: true
      # t.decimal :value
      # t.string :description
      # t.datetime :date

end