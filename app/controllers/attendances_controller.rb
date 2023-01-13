class AttendancesController < ApplicationController
  before_action :fetch_attendance, only: %i[show edit update destroy]
  def index
    @attendances = Attendance.all.order(:month)
  end

  def show
    if authorised_admin?
      @attendance = Attendance.find(params[:id])
    else
      flash[:alert] = 'Unauthorized User'
      redirect_to '/attendances'
    end
  end

  def new
    @attendance = Attendance.new
   
  end

  def create
    @attendance = Attendance.create(attendance_params)
    if authorised_admin? && @attendance.save
     @attendance = @attendance.update(working_days: find_working_days(@attendance.id))
      flash[:notice] = 'Sucessfully, saved the attendance details'
      redirect_to '/attendances'
    else
      flash[:notice] = 'Unauthorised user or invalid details'
      redirect_to '/attendances/new'
    end
  end

  def edit   
  end

  def update
    if authorised_admin?  @attendance.update(attendance_params) 
        flash[:notice] = 'Sucessfully, updated the attendance of employee'
        redirect_to '/attendances'
    else
      flash[:notice] = 'Unauthorised user'
      redirect_to '/attendances'
    end
  end

  def destroy   
    if @attendance.destroy && authorised_admin?
      flash[:notice] = 'attendance destroyed' 
      redirect_to '/attendances/'
    else
      flash[:alert] = 'Unauthorized User'
      render '/attendances/'
    end
  end



  protected
  def fetch_attendance
    @attendance = Attendance.find(params[:id]) 
  end

  def find_unpaid_leaves
    binding.pry
    leaves = Leave.where(leave_type: 'unpaid')
    @unpaid_leaves = 0
    leaves.each do |leave|
      @unpaid_leaves =  @unpaid_leaves  
    end
  end

  def find_working_days(id)
    @attendance = Attendance.find(id) 
    @office_days = 0
    date = Date.new(Date.today.year, @attendance.month, 1)
    until date  >= date.end_of_month do
      if !date.on_weekend?
        @office_days = @office_days + 1
      end
      date = date.next
    end
    @office_days
  end
  
  def attendance_params
    params.require(:attendance).permit(:month, :unpaid_leaves, :working_days, :employee_id)
  end

end
