class ApplicationController < ActionController::Base

  def authorised_admin?
    user_signed_in? && current_user.id == Admin.last.id
  end

  def authorised_employee?
   
    user_signed_in? &&  current_user == Employee.find(current_user.id) 
  end

end
