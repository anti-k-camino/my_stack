FactoryGirl.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end
  sequence :name do |n|
    "MyString#{n}"
  end
  factory :user do    
    name   
    email
    password '12345678'
    password_confirmation '12345678'  
  end
end
