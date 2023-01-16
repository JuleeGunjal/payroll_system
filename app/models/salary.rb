class Salary < ApplicationRecord

  belongs_to :employee
  
  validates :date, presence: true
  validates :total_salary, presence: true

end
