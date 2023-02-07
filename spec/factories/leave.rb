FactoryBot.define do
  factory :leave, class: Leave do
    status { 'Pending'} 	
    from_date { DateTime.now - 3.days }	
    to_date { DateTime.now } 	
    reason { 'ajdhjasdh'}	
    employee_id { Employee.all.ids[rand(9)] } 	
    leave_type { 'paid'}    
  end
end


