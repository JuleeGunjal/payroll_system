class PayslipsController < ApplicationController
  
  before_action :fetch_payslip, only: %i[show edit update destroy]
  

  def index
    if authorised_admin?
      @payslips = Payslip.all
    elsif authorised_employee?
      @payslips = Payslip.where(employee_id: current_user.id)
    else
      flash[:alert] =  I18n.t("unauthorised") 
      redirect_to root_path
    end    
  end

  def show
    @payslip = Payslip.find(params[:id])
    # if authorised_admin? || authorised_employee?
    #   @payslip = Payslip.find(params[:id])
    # else
    #   flash[:alert] =  I18n.t("unauthorised") 
    #   redirect_to root_path
    # end
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "payslips/payslip", formats: [:html], layout: 'pdf'
      end
    end  
  end

  def new
    @payslip = Payslip.new
  end

  def create
    @payslip = Payslip.new(payslip_params)
    updated_date = @payslip.date.end_of_month
    @existing_payslip = Payslip.where(employee_id: @payslip.employee_id, date: updated_date).first
    if authorised_admin? && !(@existing_payslip.present?) 
      @payslip.date = updated_date
      @payslip.taxable_income = find_taxable_income
      @payslip.payable_salary = find_payable_salary
      if  @payslip.save
        flash[:notice] = I18n.t("successful")
        redirect_to payslips_path
      else
        flash[:notice] = "Invalid details"
        redirect_to payslips_path
      end
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to payslips_path
    end
  end

  def destroy
    if @payslip.destroy && authorised_admin?
     flash[:notice] = I18n.t("destroyed") 
      redirect_to payslips_path
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to payslips_path
    end
  end

  protected

  def find_taxable_income
    employee = Employee.find(@payslip.employee_id)
    payslips = TaxDeduction.where(employee_id: employee.id)
    total_ammount = 0
    payslips.each do |payslip|
      total_ammount = total_ammount + payslip.ammount
    end
    @salary = Salary.find_by(employee_id: employee.id, date: @payslip.date.beginning_of_month)
    @package = @salary.total_salary * 12
    if total_ammount > 200000
      @package - 200000
    else
      @package - total_ammount
    end
  end

  def find_payable_salary
    employee = Employee.find(@payslip.employee_id)
    @attendance = Attendance.find_by(employee_id: employee.id, month: @payslip.date.month)
    leave_cut = @attendance.unpaid_leaves.to_i * (@salary.total_salary / find_working_days)
    tax_cut = find_tax_bracket.to_i / 12
    @salary.total_salary - leave_cut - tax_cut
  end

  def find_tax_bracket
    if @package > 1500000
      tax = 0.3 * (@package - 1500000) + 187500
    elsif @package <= 1500000 && @package > 1250000
      tax = 0.25 * (@package - 1250000) + 125000
    elsif @package <= 1250000 && @package > 1000000
      tax = 0.2 * (@package - 1000000) + 75000
    elsif @package <= 1000000 && @package > 750000
      tax = 0.15 * (@package - 750000) + 37500
    elsif @package <= 750000 && @package > 500000
      tax = 0.1 * (@package - 500000) + 12500
    elsif @package <= 500000 && @package > 250000
      tax = 0.05 * (@package - 250000)
    else
      tax = 0
    end
  end

  def find_working_days
    @office_days = 0
    date =  @payslip.date.beginning_of_month
    until date  >= @payslip.date do
      if !date.on_weekend?
        @office_days = @office_days + 1
      end
      date = date.next
    end
    @office_days
  end

  def fetch_payslip
    @payslip = Payslip.find(params[:id])
  end

  def payslip_params
    params.require(:payslip).permit(:date, :employee_id)
  end
end
