class LeavesController < ApplicationController
  
  def index
    binding.pry
    @leaves = Leave.all
  end

  def show
    binding.pry
    @leave = Leave.find(params[:id])
    if authorised_employee? || authorised_admin?
      @leave = Leave.find(params[:id])
    else
      flash[:alert] = "Unauthorized User" 
      render 'home/index'
    end
  end

  def new
    @leave = Leave.new
  end

  def create
    @leave = Leave.create(leave_params)
    if authorised_employee? && @leave.save
      flash[:notice] = "Sucessfully, saved the employee details"
      redirect_to '/leaves'
    else
      flash[:notice] = "Unauthorised user or invalid details"
      redirect_to '/leaves/new'
    end

  end

  def edit
    @leave = Leave.find(params[:id])
  
  end

  def update
    @leave = Leave.find(params[:id])
    binding.pry
   @inc = skip_weekends
    paid?
    if authorised_admin? || authorised_employee?
      if paid? && @leave.update(leave_params)
        flash[:notice] = "Sucessfully, updated the status of leave application"
        redirect_to '/leaves'
      else 
        flash[:notice] = "change the type of leaves"
        redirect_to '/leaves'
      end
    else
      flash[:notice] = "Unauthorised user "
      redirect_to '/leaves/edit'
    end
  end

  def destroy
    @leave = Leave.find(params[:id]) 
    if @leave.destroy && authorised_admin? || authorised_employee?
      flash[:notice] = " leave destroyed" 
      redirect_to '/leaves/'
    else
      flash[:alert] = "Unauthorized User" 
      render '/leaves/'
    end
  end



  protected

  def authorised_employee?
    current_user == Employee.find(@leave.employee_id)
  end

  def paid?
    @leave = fetch_leave
    count = Employee.find(@leave.employee_id).paid_leaves
    @inc = skip_weekends
    if count < @inc
      @unpaid = @inc - count
      false
    end
    true
  end
   
   
  def skip_weekends
    @leave = fetch_leave
    date = @leave.from_date
    @inc = 0
    until date <= @leave.to_date do
      if !date.on_weekend?
        @inc = inc + 1
      end
      date = date.next
    end
    @inc
  end

  def update_paid_leaves
    @leave = fetch_leave
    @employee = Employee.find(@leave.employee_id)
    @employee.paid_leaves
    @employee.update(paid_leaves)

  end

  def fetch_leave
    @leave = Leave.find(params[:id]) 
  end
  
  def leave_params
    params.require(:leave).permit(:status, :reason, :from_date, :to_date, :leave_type, :employee_id)
  end

end
