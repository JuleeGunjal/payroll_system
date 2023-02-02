FactoryBot.define do
  factory :attendance, class: Attendance do
    month { rand(1..12) }
    employee_id { Employee.all.ids[rand(9)] } 
    working_days { 20 }
    unpaid_leaves { 0 }  
  end
end