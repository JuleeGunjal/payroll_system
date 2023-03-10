class Users::EmployeesController < ApplicationController
  
  def index
    @employees = Employee.all
  end
  def show
    if authorised_admin? 
      @employee = Employee.find(params[:id])
    else
      flash[:alert] = "Unauthorized User" 
      render 'home/index'
    end
  end
  def new
    binding.pry
    if authorised_admin?
      @employee = Employee.new
    else
      flash[:alert] = "Unauthorized User" 
      render 'home/index'
    end
  end

  def create        
    @employee = Employee.create(employee_params)
    if @employee.save        
      flash[:notice] = "Sucessfully, saved the employee details"
      redirect_to '/users/employees'
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to "/users/sign_in"          
    end
  end

  def edit
    binding.pry
    @employee = Employee.find(params[:id])
  end

  def update
    binding.pry
    @employee = Employee.find(params[:id])    
    if authorised_admin? && @employee.update(employee_params)
      render 'home/index'
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to "/users/sign_in"
    end
  end

  def destroy
    @employee = Employee.find(params[:id]) 
    if @employee.destroy && authorised_admin?
      flash[:notice] = " User destroyed" 
      redirect_to '/users/employees'
    else
      flash[:alert] = "Unauthorized User" 
      render '/users/employees'
    end
  end

  protected




  def employee_params
    params.require(:employee).permit(:email, :password, :type, :first_name, :last_name, :gender, :date_of_joining, :mobile_number, :address)
  end
 

end
