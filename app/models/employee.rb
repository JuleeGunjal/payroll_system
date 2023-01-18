class Employee < User

  validates :first_name, presence: true
  has_many :leaves, dependent: :destroy, class_name: "Leave"
  has_many :attendances, dependent: :destroy, class_name: "Attendance"
  has_many :salaries, dependent: :destroy, class_name: "Salary"
  has_many :tax_deductions, dependent: :destroy, class_name: "Tax_deduction"
end
