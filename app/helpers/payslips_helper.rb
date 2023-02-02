module PayslipsHelper

  def get_salary
   employee = get_employee(@payslip.employee_id)
   salary = Salary.find_by(employee_id: employee.id, date: @payslip.date.beginning_of_month)
   salary.total_salary 
  end

  def get_name(payslip)
    Employee.find(payslip.employee_id).first_name
  end

  def get_employee(id)
    @employee = Employee.find(id)
  end

  def get_unpaid_leaves
    @attendance =  Attendance.find_by(employee_id: (@payslip.employee), month: @payslip.date.month)
    @attendance.unpaid_leaves
  end

  def get_total_leaves(employee_id, month)    
    leaves = Leave.where('extract(month from from_date) = ?',month).where(status: 'Approved').where(employee_id: employee_id)
    @total_leaves = 0
    leaves.each do |leave|
      @total_leaves = @total_leaves + (leave.to_date - leave.from_date).to_i + 1 - skip_weekends(leave)
    end  
    @total_leaves  
  end

  def skip_weekends(leave)    
    date = leave.from_date
    @office_days = 0
    until date  <= leave.to_date do
      if !date.on_weekend?
        @office_days = @office_days + 1
      end
      date = date.next
    end
    @office_days
  end


  def find_working_days    
    @office_days = 0
    date = Date.new(Date.today.year, @payslip.date.month, 1)
    until date  >= date.end_of_month do
      if !date.on_weekend?
        @office_days = @office_days + 1
      end
      date = date.next
    end
    @office_days
  end
  
  def leave_cut
    (get_salary.to_i / find_working_days.to_i) * unpaid_leaves.to_i
  end

  def tax_deductions
    deductions = TaxDeduction.where(employee_id: @payslip.employee_id)
  end
end
