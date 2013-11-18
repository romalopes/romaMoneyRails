namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
  end
end

# def make_users
#     User.create!(name: "Anderson Lopes",
#                   email: "romalopes@yahoo.com.br",
#                   password: "foobar",
#                   password_confirmation: "foobar",
#                   admin: true)

#     User.create!(name: "Example User",
#                  email: "example@romalopes.com.br",
#                  password: "foobar",
#                  password_confirmation: "foobar",
#                  admin: true)
#     5.times do |n|
#       name  = Faker::Name.name
#       email = "example-#{n+1}@romalopes.com.br"
#       password  = "password"
#       User.create!(name: name,
#                    email: email,
#                    password: password,
#                    password_confirmation: password)
#     end
# end
def make_users
    User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                 admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
end
