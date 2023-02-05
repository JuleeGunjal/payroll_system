require 'rails_helper'

RSpec.describe SalariesController, type: :controller do
  describe 'GET #index'do
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      @salary = create(:salary)
      @salraies = Salary.all
    end
    context 'test' do
      it 'display a list of all Salaries' do
        get :index
        expect(response).to render_template(:index) 
      end
    end
  end 

  describe 'GET #show'do
    before do 
      @user = create(:user, type: 'Admin')
      sign_in(@user)     
      @salary = create(:salary)
    end
    context 'Salary show' do
      it "display  employee's salary details to the admin" do
        get :show, params: {id: @salary.id }
        expect(response.status).to eq(200) 
      end
      it "display  employee's salary details to the Admin" do         
        get :show, params: {id: @salary.id }
        expect(response.status).to eq(200)
      end
      it "display  employee's salary details without login" do 
        sign_out(@user)             
        get :show, params: {id: @salary.id }
        expect(response.status).to eq(302)
      end      
    end
  
    context 'Salary show to specific employee' do
      before do 
        @user = create(:employee)
        sign_in(@user)     
        @salary = create(:salary, employee_id: @user.id)
      end
      it "display  employee's salary details to the employee" do
        get :show, params: {id: @salary.id }
        expect(response.status).to eq(200) 
      end
    end
  
      it "Not to display employee's salary details to other employee" do
        sign_out(@user)       
        get :show, params: {id: @salary.id }
        expect(response.status).to eq(302) 
      end
    end



  context 'PUT update' do    
    before do      
      @salary = create(:salary)
    end
    it 'should update salary by Admin' do  
      @user = create(:user, type: 'Admin')
      sign_in(@user)   
      put :update, params: {
        salary: {
        total_salary: 50000, 
        employee_id: Employee.all.ids[rand(9)], 
        date: DateTime.now 
        }, id: @salary.id  
      }
      expect(@salary.reload.total_salary).to eq(50000)
    end
  
  
    it 'should not update salary by Admin with missing fields' do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      put :update, params: {
        salary: {
          total_salary: 50000,  
          date: DateTime.now 
          }, id: @salary.id  
      }
      expect(response.status).to eq(302)
    end  

    it 'should not update salary by Employee' do  
      @user = create(:employee)
      sign_in(@user)   
      put :update, params: {
        salary: {
          total_salary: 50000, 
          employee_id: Employee.all.ids[rand(9)], 
          date: DateTime.now 
          }, id: @salary.id  
      }
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE destroy' do   
    before do      
      @user = create(:user, type: 'Admin')
      @salary = create(:salary)      
    end
    it 'should delete the Salary' do 
      salaries_count = Salary.all.count
      sign_in(@user)
      delete :destroy, params: { id: @salary.id }
      expect(Salary.all.count).to eq(salaries_count-1)
    end
    it 'should not delete the salary' do
      salaries_count = Salary.all.count
      @salary = create(:salary)  
      delete :destroy, params: { id: @salary.id } 
      expect(Salary.all.count).to eq(salaries_count)
    end
  end

  # context 'Post create' do    
  #   before do 
  #     @user = create(:user, type: 'Admin')
  #     sign_in(@user)       
  #   end
  #   it 'should create attendance by Admin' do 
  #     attendances_count = Attendance.all.count       
  #     post :create, params: {
  #       attendance: {
  #           month: rand(1..12),
  #           working_days: 20,
  #           unpaid_leaves: 6,
  #           employee_id: Employee.all.ids[rand(9)]        
  #       } 
  #     }
  #     expect(Attendance.all.count).to eq(attendances_count + 1)
  #   end
  

  #   it 'should not  create leave by Employee as all attributes not provided' do 
  #     attendances_count = Attendance.all.count       
  #     post :create, params: {
  #       attendance: {
  #         month: rand(1..12),
  #         working_days: 20,
  #         unpaid_leaves: 6         
  #       } 
  #     }
  #     expect(Attendance.all.count).to eq(attendances_count )
  #   end
  
  #   it 'should not  create leave by Employee as no authorised employee present' do 
  #     sign_out(@user)
  #     attendances_count = Attendance.all.count       
  #     post :create, params: {
  #       attendance: {
  #         month: rand(1..12),
  #         working_days: 20,
  #         unpaid_leaves: 6,
  #         employee_id: Employee.all.ids[rand(9)]        
  #       } 
  #     }
  #     expect(Attendance.all.count).to eq(attendances_count)
  #   end
  # end
end