require 'rails_helper'

RSpec.describe Users::EmployeesController, type: :controller do
  context 'POST /users' do    
    before do
      @request.env['devise.mapping'] = Devise.mappings[:employee]
     

    end
    it 'should register users with valid details' do
      post :create , params: {
        employee: {
          email: "kiya@gmail.com",
          password: "Josh@123",
          first_name: "abc",
          last_name: "xyz",
          mobile_number: "8989456789",
          type: 'Employee',
          date_of_joining: '2023-01-01',
          gender: 'male',
          address: 'pqr'          
        }
      }

      expect(response.status).to eq(302)
    end
  end  

  context 'POST /users' do   
    before do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      post :create , params: {
        employee: {
          email: "623575@gmail.com",
          password: "Josh@123",
          first_name: "abc",
          last_name: "xyz",
          mobile_number: "------",
          type: 'Employee',
          date_of_joining: '2023-01-01',
          gender: 'male',
          address: 'pqr'
        }
      }
    end
    it 'should not register users with invalid details' do
      expect(response.status).to eq(302)
    end
  end
end