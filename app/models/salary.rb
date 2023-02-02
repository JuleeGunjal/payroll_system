class Salary < ApplicationRecord

  belongs_to :employee 

  validates :total_salary, :employee_id, :date, presence: true

end
