class Employee < User

  validates :first_name, presence: { message: I18n.t("blank") }
  validates :last_name, presence: { message: I18n.t("blank") }
  validates :gender, presence: { message: I18n.t("blank") }
  validates :mobile_number, presence:{ message: I18n.t("blank") }, uniqueness: { message: I18n.t("unique") }
  validates :date_of_joining, comparison: { less_than: Date.today, message: 'Date should be previous to now'}
  validates :address, presence: { message: I18n.t("blank") }
  validates :type, presence: { message: I18n.t("blank") }

  has_many :leaves, dependent: :destroy, class_name: "Leave"
  has_many :attendances, dependent: :destroy, class_name: "Attendance"
  has_many :salaries, dependent: :destroy, class_name: "Salary"
  has_many :tax_deductions, dependent: :destroy, class_name: "Tax_deduction"
  has_many :payslips, dependent: :destroy, class_name: "Payslip"

end
