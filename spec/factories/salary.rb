FactoryBot.define do
  factory :salary, class: Salary do
    total_salary { rand(99999) } 
    employee_id { Employee.all.ids[rand(9)] } 
    date { DateTime.now }
	
     
  end
end


