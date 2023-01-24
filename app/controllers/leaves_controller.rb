class LeavesController < ApplicationController
  after_action :update_paid_leaves, only: :update, if: :paid?

  def index
    if authorised_admin?
      @leaves = Leave.all
    elsif authorised_employee?
      @leaves = Leave.where(employee_id: current_user.id)
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to root_path
    end       
  end

  def show    
    @leave = Leave.find(params[:id])
    if authorised_admin? ||  authorised_employee?  
      @leave = Leave.find(params[:id])
    else
      flash[:alert] = "Unauthorized User" 
      redirect_to root_path
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
    if authorised_admin? || authorised_employee?
      if paid? && @leave.update(leave_params) && @leave.status == 'Pending' 
        flash[:notice] = "Sucessfully, updated the status of leave application"
        redirect_to '/leaves'
      elsif @leave.update(leave_params)
        @leave.update(leave_type: 'unpaid')
        flash[:notice] = "Sucessfully, updated the status of leave application with type unpaid leave"
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


  def paid?
    @leave = fetch_leave
    leave_count = Employee.find(@leave.employee_id).paid_leaves
    count = @leave.to_date - @leave.from_date + 1
    @office_days = skip_weekends
    if leave_count < count
      false
    end
    true
  end
   
  def skip_weekends
    @leave = fetch_leave
    date = @leave.from_date
    @office_days = 0
    until date  <= @leave.to_date do
      if !date.on_weekend?
        @office_days = office_days + 1
      end
      date = date.next
    end
    @office_days
  end
 

  def update_paid_leaves
    @leave = fetch_leave
    count = @leave.to_date - @leave.from_date + 1
    if @leave.status == 'Approved'
      count = (count - @office_days) + 1
      employee = @leave.employee
      employee.update(paid_leaves: employee.paid_leaves - count)
    end
  end

  def fetch_leave
    @leave = Leave.find(params[:id]) 
  end
  
  def leave_params
    params.require(:leave).permit(:status, :reason, :from_date, :to_date, :leave_type, :employee_id)
  end

 end
