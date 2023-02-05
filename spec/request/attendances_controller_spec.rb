require 'rails_helper'

RSpec.describe AttendancesController, type: :controller do
  describe 'GET #index'do
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      @attendance = create(:attendance)
      @attendances = Attendance.all
    end
    context 'test' do
      it 'display a list of all Attendances' do
        get :index
        expect(response).to render_template(:index) 
      end
    end
  end 

  describe 'GET #show'do
    before do 
      @user = create(:user, type: 'Admin')
      sign_in(@user)     
      @attendance = create(:attendance)
    end
    context 'Attendance show' do
      it "display  employee's attendance details to the admin" do
        get :show, params: {id: @attendance.id }
        expect(response.status).to eq(200) 
      end
      it "display  employee's leave details to the Admin" do         
        get :show, params: {id: @attendance.id }
        expect(response.status).to eq(200) 
      end
      it "display  employee's leave details without login" do 
        sign_out(@user)             
        get :show, params: {id: @attendance.id }
        expect(response.status).to eq(302)
      end      
    end

    context 'Attendance show to specific employee' do
      before do 
        @user = create(:employee)
        sign_in(@user)     
        @attendance = create(:attendance, employee_id: @user.id)
      end
      it "display  employee's attendance details to the employee" do
        get :show, params: {id: @attendance.id }
        expect(response.status).to eq(200) 
      end

      it "display  employee's attendance details to the employee" do
        sign_out(@user)
        get :show, params: {id: @attendance.id }
        expect(response.status).to eq(302) 
      end
    end
  end 


  context 'PUT update' do    
    before do      
      @attendance = create(:attendance)
    end
    it 'should update attendance by Admin' do  
      @user = create(:user, type: 'Admin')
      sign_in(@user)   
      put :update, params: {
        attendance: {
          month: rand(1..12),
          working_days: 20,
          unpaid_leaves: 6, 
        }, id: @attendance.id  
      }
      expect(@attendance.reload.unpaid_leaves).to eq('6')
    end
  
    it 'should not update attendance by Admin with missing fields' do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      put :update, params: {
        attendance: {
          month: rand(1..12),
          working_days: 20         
        }, id: @attendance.id  
      }
      expect(@attendance.reload.unpaid_leaves).to eq('0')
    end
  
    it 'should not update attendance by Employee' do  
      @user = create(:employee)
      sign_in(@user)   
      put :update, params: {
        attendance: {
          month: rand(1..12),
          working_days: 20,
          unpaid_leaves: 6 
        }, id: @attendance.id  
      }
      expect(response.status).to eq(302)
    end
  end

  context 'DELETE destroy' do   
    before do      
      @user = create(:user, type: 'Admin')     
      @attendance = create(:attendance)      
    end
    it 'should delete the attendance' do 
      attendances_count = Attendance.all.count
      sign_in(@user)
      delete :destroy, params: { id: @attendance.id }
      expect(Attendance.all.count).to eq(attendances_count-1)
    end
    it 'should not delete the attendance' do
      attendances_count = Attendance.all.count
      @attendance = create(:attendance) 
      delete :destroy, params: { id: @attendance.id } 
      expect(Attendance.all.count).to eq(attendances_count)
    end
  end

  context 'Post create' do    
    before do 
      @user = create(:user, type: 'Admin')
      sign_in(@user)       
    end
    it 'should create attendance by Admin' do 
      attendances_count = Attendance.all.count       
      post :create, params: {
        attendance: {
            month: rand(1..12),
            working_days: 20,
            unpaid_leaves: 6,
            employee_id: Employee.all.ids[rand(9)]        
        } 
      }
      expect(Attendance.all.count).to eq(attendances_count + 1)
    end
  

    it 'should not  create leave by Employee as all attributes not provided' do 
      attendances_count = Attendance.all.count       
      post :create, params: {
        attendance: {
          month: rand(1..12),
          working_days: 20,
          unpaid_leaves: 6         
        } 
      }
      expect(Attendance.all.count).to eq(attendances_count )
    end
  
    it 'should not  create leave by Employee as no authorised employee present' do 
      sign_out(@user)
      attendances_count = Attendance.all.count       
      post :create, params: {
        attendance: {
          month: rand(1..12),
          working_days: 20,
          unpaid_leaves: 6,
          employee_id: Employee.all.ids[rand(9)]        
        } 
      }
      expect(Attendance.all.count).to eq(attendances_count)
    end
  end
end