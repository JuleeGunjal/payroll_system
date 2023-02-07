FactoryBot.define do
  factory :user, class: User do
    email { Faker::Internet.email }

    password { 'Josh@123' }
   
  end
end