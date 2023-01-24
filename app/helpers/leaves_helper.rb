module LeavesHelper
  def get_name(leave)
    Employee.find(leave.employee_id).first_name
  end
end
