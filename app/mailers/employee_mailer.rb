# frozen_string_literal: true

class EmployeeMailer < ApplicationMailer
  def welcome_email
    @employee = params[:employee]
    @url = 'http://localhost:3000/users/sign_in'
    @passwordurl = 'http://localhost:3000/users/password/new'
    mail(to: @employee.email, subject: 'Welcome to Payroll System')
  end
end
