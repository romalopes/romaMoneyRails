namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_accounts
  end
end

def make_users
    User.create!(name: "Anderson Lopes",
                 email: "romalopes@yahoo.com.br",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true,
                 current_account_id: 1)

    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    2.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
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