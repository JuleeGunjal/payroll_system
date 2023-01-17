class SalariesController < ApplicationController
  before_action :fetch_salary, only: %i[show edit update destroy]
  def index
    @salaries = Salary.all
  end

  def show
    @salary = Salary.find(params[:id])
    if authorised_admin?
      @salary = Salary.find(params[:id])
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to root_path
    end
  end

  def new
    @salary = Salary.new
  end

  def create
    @salary = Salary.new(salary_params)
    updated_date = @salary.date.beginning_of_month
    @existing_salary = Salary.where(employee_id: @salary.employee_id, date: updated_date).first
    if authorised_admin? && !(@existing_salary.present?) 
      @salary.date = updated_date
      if  @salary.save
        flash[:notice] = "Sucessfully, saved the employee's salary details"
        redirect_to salaries_path
      else
        flash[:notice] = "Invalid details"
        redirect_to salaries_path
      end
    else
      flash[:notice] = "Unauthorised user or already entry exist"
      redirect_to edit_salary_path(@existing_salary)
    end
  end

  def edit 
  end

  def update
    if @salary.update(salary_params) 
        flash[:notice] = 'Sucessfully, updated the attendance of employee'
        redirect_to salaries_path
    else
      flash[:notice] = 'Unauthorised user'
      redirect_to salaries_path
    end
  end


  def destroy   
    if @salary.destroy && authorised_admin?
      flash[:notice] = 'salary destroyed' 
      redirect_to salaries_path
    else
      flash[:alert] = 'Unauthorized User'
      redirect_to salaries_path
    end
  end

  protected

  def fetch_salary
    @salary = Salary.find(params[:id]) 
  end

  def salary_params
    params.require(:salary).permit(:date, :total_salary, :employee_id)
  end

end