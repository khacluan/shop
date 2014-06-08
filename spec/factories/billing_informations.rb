# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :billing_information do
    user_id 1
    address "MyString"
    first_name "MyString"
    last_name "MyString"
    city "MyString"
    zip_code "MyString"
    country_id 1
    state "MyString"
    tel "MyString"
  end
end
