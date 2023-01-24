module SalariesHelper

  def get_name(salary)
    Employee.find(salary.employee_id).first_name
  end
end
