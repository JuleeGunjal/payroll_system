class Employee < User

  validates :first_name, presence: { message: I18n.t("blank") }
  validates :last_name, presence: { message: I18n.t("blank") }
  validates :gender, presence: { message: I18n.t("blank") }
  validates :mobile_number, presence:{ message: I18n.t("blank") }, uniqueness: { message: I18n.t("unique") }
  validates :address, presence: { message: I18n.t("blank") }
  validates :type, presence: { message: I18n.t("blank") }
  validates :date_of_joining, comparison: { less_than: Date.today, message: 'Date should be previous to now'}

  has_many :leaves, dependent: :destroy, class_name: "Leave"
  has_many :attendances, dependent: :destroy, class_name: "Attendance"
  has_many :salaries, dependent: :destroy, class_name: "Salary"
  has_many :tax_deductions, class_name: "Tax_deduction"
  has_many :payslips, dependent: :destroy, class_name: "Payslip"
   
  after_save :send_welcome_mail

  def send_welcome_mail
    EmployeeMailer.with(employee: self).welcome_email.deliver_now
  end

end
