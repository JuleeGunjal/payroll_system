require 'rails_helper'

RSpec.describe Users::EmployeesController, type: :controller do
  describe 'GET #index'do
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      @employee = create(:employee)
      @employees = Employee.all
    end
    context 'test' do
      it 'display a list employees' do
        get :index
        expect(response).to render_template(:index) 
      end
    end
  end 

  describe 'GET #show'do
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user) 
      @employee = create(:employee)
    end
    context 'test' do
      it "display  employee's details" do        
        get :show, params: {id: @employee.id }
        expect(response).to render_template(:show) 
      end
    end
  end 


  context 'PUT update' do    
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user) 
      @employee = create(:employee)
    end
    it 'should update user' do
      put :update, params: {
        employee: {
          gender: Faker::Gender.binary_type,
          dob: Faker::Date.in_date_period,
          city: Faker::Address.city,
          country: Faker::Address.country,
          address: Faker::Address.full_address,
          pincode: Faker::Number.number(digits: 6)
        }, id: user.id  
      }
      expect(response.status).to eq(200)
    end
    it 'should not update the user with missing fields' do
      put :update, params: {
        user: {
          gender: Faker::Gender.binary_type,
          dob: Faker::Date.in_date_period,
          country: Faker::Address.country,
          address: Faker::Address.full_address,
          pincode: Faker::Number.number(digits: 6)
        }, id: user.id  
      }
      expect(response.status).to eq(422)
    end
  end

end