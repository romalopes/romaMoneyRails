namespace :db do
  desc "Fill database with sample data"
  puts "Fill database with sample data"
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
                 password: "romalopes",
                 password_confirmation: "romalopes",
                 admin: true)

    User.create!(name: "Cida",
                 email: "cydynha@msn.com",
                 password: "foobar",
                 password_confirmation: "foobar")

    User.create!(name: "Anderson Gmail",
                 email: "romalopes@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")

    User.create!(name: "Anderson Gmail 2",
                 email: "romalopes2@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
end

def make_accounts
    users = User.all
    userYahoo  = users.find_by(email: "romalopes@yahoo.com.br")
    userGmail  = users.find_by(email: "romalopes@gmail.com")
    userGmail2  = users.find_by(email: "romalopes2@gmail.com")

    #Create fake accounts
    name = "YahooAccount1"
    description = "description of account1"
    yahooAccount1 = userYahoo.accounts.create!(name: name, user: userYahoo)
    userYahoo.set_first_account_possible

    name = "YahooAccount2"
    description = "description of account2"
    yahooAccount2 = userYahoo.accounts.create!(name: name, user: userYahoo)

    name = "GmailAccount1"
    description = "description of account1"
    gmailAccount1 = userGmail.accounts.create!(name: name, user: userGmail)

    name = "GmailAccount2"
    description = "description of account2"
    gmailAccount2 = userGmail.accounts.create!(name: name, user: userGmail)
    userGmail.set_first_account_possible

    name = "Gmail_2_Account"
    description = "description of account "
    gmail2Account = userGmail2.accounts.create!(name: name, user: userGmail2)
    userGmail2.set_first_account_possible

    user_account = UserAccount.create!(user_id:userGmail2.id, account_id: gmailAccount1.id)

    user_account = UserAccount.create!(user_id:userGmail.id, account_id: gmail2Account.id)
end

def make_transactions
  study_category = Category.find_by(name:"Study")
  transport_category = Category.find_by(name:"Transport")
  salary_category = Category.find_by(name:"Salary")
  house_category = Category.find_by(name:"House")

  users = User.all
  userYahoo  = users.find_by(email: "romalopes@yahoo.com.br")
  userGmail  = users.find_by(email: "romalopes@gmail.com")
  userGmail2  = users.find_by(email: "romalopes2@gmail.com")

  yahooAccount1 = userYahoo.accounts.find_by(name:"YahooAccount1")
  gmailAccount1 = userGmail.accounts.find_by(name:"GmailAccount1")
  gmail2Account = userGmail2.accounts.find_by(name:"Gmail_2_Account")

  Transaction.create!(name:"Salary",
                      value: 10000,
                      date: Date.parse(Time.now.to_s),
                      category:salary_category,
                      account:gmailAccount1)

  Transaction.create!(name:"School",
                      value: 500,
                      date: Date.parse(Time.now.to_s),
                      category:study_category,
                      account:gmailAccount1)

  Transaction.create!(name:"Rent",
                      value: 1500,
                      date: Date.parse(Time.now.to_s),
                      category:house_category,
                      account:gmailAccount1)

  Transaction.create!(name:"Salary",
                      value: 7500,
                      date: Date.parse(Time.now.to_s),
                      category:salary_category,
                      account:gmail2Account)

  Transaction.create!(name:"Transport",
                      value: 120,
                      date: Date.parse(Time.now.to_s),
                      category:transport_category,
                      account:gmail2Account)

    Transaction.create!(name:"Rent",
                      value: 1000,
                      date: Date.parse(Time.now.to_s),
                      category:house_category,
                      account:gmail2Account)
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

