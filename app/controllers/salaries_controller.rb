class SalariesController < ApplicationController
  before_action :fetch_salary, only: %i[show edit update destroy]

  def index      
    if authorised_admin? 
      @salaries = Salary.all
    elsif authorised_employee?
      @salaries = Salary.where(employee_id: current_user.id)
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to root_path
    end
  end

  def show
    @salary = Salary.find(params[:id])
    if authorised_admin? || authorised_employee?
      @salary = Salary.find(params[:id])
    else
      flash[:alert] =  I18n.t("unauthorised") 
      redirect_to root_path
    end
  end

  def new
    if authorised_admin? 
      @salary = Salary.new
    else
      flash[:alert] =  I18n.t("unauthorised") 
      redirect_to root_path
    end
  end

  def create
    @salary = Salary.new(salary_params)
    updated_date = @salary.date.beginning_of_month
    @existing_salary = Salary.where(employee_id: @salary.employee_id, date: updated_date).first
    if authorised_admin?
      if !(@existing_salary.present?) 
        @salary.date = updated_date
        if @salary.save
          flash[:notice] = I18n.t("successful")
          redirect_to salaries_path
        else
          flash[:notice] = "Invalid details"
          redirect_to salaries_path
        end
      else
        flash[:alert] = 'Already exits'
        redirect_to salaries_path
      end        
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to salaries_path
    end
    
  end

  def edit
  end

  def update
    if authorised_admin? && @salary.update(salary_params) 
      flash[:notice] = I18n.t("successful")
      redirect_to salaries_path
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to root_path
    end
  end


  def destroy   
    if @salary.destroy && authorised_admin?
      flash[:notice] = I18n.t("destroyed")
      redirect_to salaries_path
    else
      flash[:alert] =  I18n.t("unauthorised")
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
