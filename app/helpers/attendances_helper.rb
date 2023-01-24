module AttendancesHelper

  def get_name(attendance)
    Employee.find(attendance.employee_id).first_name
  end

end
