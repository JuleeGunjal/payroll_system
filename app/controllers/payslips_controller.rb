# frozen_string_literal: true

class PayslipsController < ApplicationController
  before_action :fetch_payslip, only: %i[show edit update destroy]

  def index
    if authorised_admin?
      @payslips = if params[:search]
                    Payslip.where(date: params[:search].to_date.end_of_month)
                   else
                    Payslip.all
                  end
    elsif authorised_employee?
      @payslips = if params[:search]
                    Payslip.where(date: params[:search].to_date.end_of_month, employee_id: current_user.id)
                  else
                    Payslip.where(employee_id: current_user.id)
                  end
    else
      flash[:alert] = I18n.t('unauthorised')
      redirect_to root_path
    end        
  end

  def show
    if authorised_admin? || authorised_employee?
      @payslip = Payslip.find(params[:id])
      respond_to do |format|
        format.html
        format.pdf do
          render pdf: 'file_name', template: 'payslips/payslip', formats: [:html], layout: 'pdf'
        end
      end
    else
      flash[:alert] = I18n.t('unauthorised')
      redirect_to root_path
    end
  end

  def new
    if authorised_admin?
      @payslip = Payslip.new
    else
      flash[:alert] = I18n.t('unauthorised')
      redirect_to root_path
    end
  end

  def create
    @payslip = Payslip.new(payslip_params)
    updated_date = @payslip.date.end_of_month
    @existing_payslip = Payslip.where(employee_id: @payslip.employee_id, date: updated_date).first
    if authorised_admin? && !@existing_payslip.present?
      @payslip.date = updated_date
      if helpers.is_salary? && helpers.is_attendance?
        @payslip.taxable_income = find_taxable_income
        @payslip.payable_salary = find_payable_salary
        if @payslip.save
          flash[:notice] = I18n.t('successful')
          redirect_to payslips_path
        else
          flash[:notice] = I18n.t('unsuccessful')
          redirect_to root_path
        end
      else
        flash[:notice] = 'Add Salary and Attendance'
        redirect_to root_path
      end
    else
      flash[:alert] = 'Payslip generated or unauthorised'
      redirect_to payslips_path
    end
  end

  def destroy
    if @payslip.destroy && authorised_admin?
      flash[:notice] = I18n.t('destroyed')
    else
      flash[:alert] = I18n.t('unauthorised')
    end
    redirect_to payslips_path
  end

  protected

  def find_taxable_income
    employee = helpers.fetch_employee
    total_salary = helpers.get_salary
    payslips = TaxDeduction.where(employee_id: employee.id)
    total_ammount = 0
    payslips&.each do |payslip|
      total_ammount += payslip.ammount
    end
    @package = total_salary * 12
    if total_ammount > 200_000
      @package - 200_000
    else
      @package - total_ammount
    end
  end

  def find_payable_salary
    total_salary = helpers.get_salary
    if helpers.is_attendance? && helpers.is_salary?
      leave_cut = helpers.get_unpaid_leaves.to_i * (total_salary / find_working_days)
      tax_cut = find_tax_bracket.to_i / 12
      total_salary - leave_cut - tax_cut
    else
      flash[:alert] = 'add atendance'
    end
  end

  def find_tax_bracket
    tax = if @package > 1_500_000
            0.3 * (@package - 1_500_000) + 187_500
          elsif @package <= 1_500_000 && @package > 1_250_000
            0.25 * (@package - 1_250_000) + 125_000
          elsif @package <= 1_250_000 && @package > 1_000_000
            0.2 * (@package - 1_000_000) + 75_000
          elsif @package <= 1_000_000 && @package > 750_000
            0.15 * (@package - 750_000) + 37_500
          elsif @package <= 750_000 && @package > 500_000
            0.1 * (@package - 500_000) + 12_500
          elsif @package <= 500_000 && @package > 250_000
            0.05 * (@package - 250_000)
          else
            0
          end
  end

  def find_working_days
    @office_days = 0
    date = @payslip.date.beginning_of_month
    until date >= @payslip.date
      @office_days += 1 unless date.on_weekend?
      date = date.next
    end
    @office_days
  end

  def fetch_payslip
    @payslip = Payslip.find(params[:id])
  end

  def payslip_params
    params.require(:payslip).permit(:date, :employee_id, :search)
  end
end
