# Read about factories at https://github.com/thoughtbot/factory_girl

# FactoryGirl.define do
#   factory :user do
#     name "MyString"
#     email "MyString"
#   end
# end


FactoryGirl.define do 
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end
  factory :account do
    name "AccountA"
    description "First Account"
    balance 1.0
    user
  end
  #user.current_account_id = account.id

  factory :accountA1 do
  	name "AccountA1"
  	description "First Account"
  	balance 50.0
  	user
  end
  factory :accountA2 do
    name "AccountA2"
    description "Second Account"
    balance -40.0
    user
  end
  factory :account3 do
    name "AccountA3"
    description "Second Account"
    balance 0.0
    user
  end
  factory :group_category do
    name "Group 1"
    image "image"
    group_type "group_type"
  end
  factory :category do
    name "Category"
    image "image"
    description "Description"
    group_category
  end
  factory :transaction do
    name "Transaction"
    description "Description"
    value 100.0
    account
    category
  end
end