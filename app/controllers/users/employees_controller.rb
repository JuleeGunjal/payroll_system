# frozen_string_literal: true

module Users
  class EmployeesController < ApplicationController
    def index
      if authorised_admin?
        @employees = Employee.all
      else
        flash[:alert] = 'Unauthorized User'
        redirect_to root_path
      end
    end

    def show
      if authorised_admin?
        @employee = Employee.find(params[:id])
      else
        flash[:alert] = 'Unauthorized User'
        redirect_to root_path
      end
    end

    def new
      if authorised_admin?
        @employee = Employee.new
      else
        flash[:alert] = 'Unauthorized User'
        redirect_to root_path
      end
    end

    def create
      @employee = Employee.create(employee_params)
      if @employee.save
        flash[:notice] = 'Sucessfully, saved the employee details'
        redirect_to '/users/employees'
      else
        flash[:alert] = 'Unauthorized User'
        redirect_to '/users/sign_in'
      end
    end

    def edit
      @employee = Employee.find(params[:id])
    end

    def update
      @employee = Employee.find(params[:id])
      if authorised_admin? && @employee.update(employee_update_params)
        redirect_to users_employees_path
      else
        flash[:alert] = 'Unauthorized User'
        redirect_to root_path
      end
    end

    def destroy
      @employee = Employee.find(params[:id])
      if @employee.destroy && authorised_admin?
        flash[:notice] = ' User destroyed'
        redirect_to '/users/employees'
      else
        flash[:alert] = 'Unauthorized User'
        redirect_to root_path
      end
    end

    protected

    def employee_params
      params.require(:employee).permit(:email, :password, :type, :first_name, :last_name, :gender, :date_of_joining,
                                       :mobile_number, :address)
    end

    def employee_update_params
      params.require(:employee).permit(:email, :first_name, :last_name, :gender, :date_of_joining, :mobile_number,
                                       :address, :paid_leaves)
    end
  end
end
