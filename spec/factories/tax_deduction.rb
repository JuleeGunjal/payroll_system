FactoryBot.define do
  factory :tax_deduction, class: TaxDeduction do
    arr = ['NPS', 'Non-NPS'] 
    tax_type { arr.sample }
    ammount { rand(99999)}
    employee_id { Employee.all.ids[rand(9)] } 
    financial_year { Date.today.year }
  end
end