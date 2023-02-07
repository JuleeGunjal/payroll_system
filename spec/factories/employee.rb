
FactoryBot.define do
  factory :employee, class: Employee do
    email { Faker::Internet.email }
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
    address { Faker::Address }
    mobile_number { rand(9999999999) }
    password { 'Josh@123' }
    gender { 'male' }
    date_of_joining { DateTime.now - 1.year }
    type { 'Employee'}
    paid_leaves { 10 }
  end
end