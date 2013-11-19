# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction do
    name "MyString"
    category nil
    account nil
    value "9.99"
    description "MyString"
    date "2013-11-19 12:02:01"
  end
end
