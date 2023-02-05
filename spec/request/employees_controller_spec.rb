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
        expect(response.status).to eq(200) 
      end
    end
  end 


  context 'PUT update' do    
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user) 
      @employee = create(:employee)
    end
    it 'should update employee' do 
      put :update, params: {
        employee: {
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: 'hdsh',
          address: Faker::Address,
          mobile_number: rand(9999999999),          
          gender:'male',
          date_of_joining: DateTime.now - 1.year,          
          paid_leaves: rand(9)        
        }, id: @employee.id  
      }
      expect(@employee.reload.last_name).to eq('hdsh')
    end

    it 'should not update the employee with missing fields' do
      put :update, params: {
        employee: {
          email: Faker::Internet.email,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,          
          mobile_number: rand(9999999999),
          address: Faker::Address.full_address         
        }, id: @employee.id  
      }
      expect(@employee.reload.date_of_joining).to eq((DateTime.now - 1.year).to_date)
    end
  end

  context 'DELETE destroy' do   
    before do 
      @user = create(:user, type: 'Admin')
      sign_in(@user) 
      @employee = create(:employee)
            
    end
    it 'should delete the employee' do 
      employees_count = Employee.all.count 
      delete :destroy, params: { id: @employee.id }    
      get :index
      expect(Employee.all.count).to eq(employees_count - 1)
    end
    it 'should delete the employee' do
      get :index
      expect(response).to render_template(:index)
    end
  end

end