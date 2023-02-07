class AttendancesController < ApplicationController
  before_action :fetch_attendance, only: %i[show edit update destroy]

  def index
    if authorised_admin?
      @attendances = Attendance.all.order(:month)
    elsif authorised_employee?
      @attendances = Attendance.where(employee_id: current_user.id)
    else
      flash[:alert] =  I18n.t("unauthorised") 
      redirect_to root_path
    end
  end

  def show
    if authorised_admin? || authorised_employee?
      @attendance = Attendance.find(params[:id])
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to '/attendances'
    end
  end

  def new
    @attendance = Attendance.new   
  end

  def create
    @attendance = Attendance.new(attendance_params)
    if !(Attendance.find_by(month: @attendance.month, employee_id: @attendance.employee_id))
      if  authorised_admin? && @attendance.save
        @attendance = @attendance.update(working_days: find_working_days(@attendance.id), unpaid_leaves: find_total_unpaid_leaves(@attendance.id))        
        flash[:notice] = I18n.t("successful") 
        redirect_to '/attendances'
      else
        flash[:alert] =  I18n.t("unauthorised")
        redirect_to '/attendances'
      end
    else
      flash[:alert] =  'Already exits'
      redirect_to '/attendances'
    end
  end

  def edit   
  end

  def update
    if @attendance.update(attendance_params) 
      flash[:notice] = I18n.t("successful")
      redirect_to '/attendances'
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to '/attendances'
    end
  end

  def destroy   
    if @attendance.destroy && authorised_admin?
      flash[:notice] = I18n.t("destroyed")
      redirect_to '/attendances'
    else
      flash[:alert] =  I18n.t("unauthorised")
      redirect_to '/attendances'
    end
  end


  protected

  def fetch_attendance
    @attendance = Attendance.find(params[:id]) 
  end

  def find_total_unpaid_leaves(id)
    @attendance = Attendance.find(id)
    @attendance.working_days = find_working_days(@attendance.id)
    leaves = Leave.where('extract(month from from_date) = ?', @attendance.month).where(leave_type: 'unpaid').where(employee_id: @attendance.employee_id)
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
