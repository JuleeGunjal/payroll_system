require 'rails_helper'

RSpec.describe LeavesController, type: :controller do
  describe 'GET #index'do
    before do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      @leave = create(:leave)
      @leaves = Leave.all
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
      @leave = create(:leave)
    end
    context 'leave show' do
      it "display  employee's leave details to the employee" do
        @user = create(:user, type: 'Employee')
        sign_in(@user)      
        get :show, params: {id: @leave.id }
        expect(response.status).to eq(200) 
      end
      it "display  employee's leave details to the Admin" do         
        @user = create(:user, type: 'Admin')
        sign_in(@user)       
        get :show, params: {id: @leave.id }
        expect(response.status).to eq(200) 
      end
      it "display  employee's leave details without login" do              
        get :show, params: {id: @leave.id }
        expect(response.status).to eq(302)
      end
    end
  end 


  context 'PUT update' do    
    before do      
      @leave = create(:leave)
    end
    it 'should update leave by Admin' do  
      @user = create(:user, type: 'Admin')
      sign_in(@user)   
      put :update, params: {
        leave: {
          status:'Approved',	
          from_date: DateTime.now - 3.days,
          to_date: DateTime.now, 	
          reason: 'ajdhjasdh',	
          employee_id: Employee.all.ids[rand(9)],
          leave_type:'paid'
        }, id: @leave.id  
      }
      expect(@leave.reload.status).to eq('Approved')
    end

    it 'should not update leave by Admin with missing fields' do
      @user = create(:user, type: 'Admin')
      sign_in(@user)
      put :update, params: {
        leave: {
          status:'Approved',	
          from_date: DateTime.now - 3.days,
          to_date: DateTime.now, 	
          reason: 'ajdhjasdh',	
          employee_id: Employee.all.ids[rand(9)],                    
        }, id: @leave.id  
      }
      expect(@leave.reload.leave_type).to eq('unpaid')
    end

    it 'should update leave by Employee' do  
      @user = create(:user, type: 'Employee')
      sign_in(@user)   
      put :update, params: {
        leave: {
          status:'Pending',	
          from_date: DateTime.now - 3.days,
          to_date: DateTime.now, 	
          reason: 'ajdhjasdh',	
          employee_id: Employee.all.ids[rand(9)],
          leave_type:'paid'           
        }, id: @leave.id  
      }
      expect(@leave.reload.from_date).to eq((DateTime.now - 3.days).to_date)
    end
  end

  context 'DELETE destroy' do   
    before do      
      @user = create(:user, type: 'Admin')     
      @leave = create(:leave)      
    end
    it 'should delete the employee' do 
      leaves_count = Leave.all.count
      sign_in(@user)
      delete :destroy, params: { id: @leave.id }
      expect(Leave.all.count).to eq(leaves_count-1)
    end
    it 'should not delete the employee' do
      leaves_count = Leave.all.count
      @leave = create(:leave)
      delete :destroy, params: { id: @leave.id } 
      expect(Leave.all.count).to eq(leaves_count)
    end
  end

  context 'Post create' do    
    before do 
      @user = create(:employee)
      sign_in(@user)       
    end
    it 'should create leave by Employee' do 
      leaves_count = Leave.all.count       
      post :create, params: {
        leave: {
          status: 'Pending'	,
          from_date: DateTime.now - 3.days,	
          to_date: DateTime.now,	
          reason: 'ajdhjasdh',
          employee_id: @user.id, 	
          leave_type: 'paid' 
        } 
      }
      expect(Leave.all.count).to eq(leaves_count + 1)
    end

    it 'should not  create leave by Employee as all attributes not provided' do 
      leaves_count = Leave.all.count       
      post :create, params: {
        leave: {
          status: 'Pending'	,
          from_date: DateTime.now - 3.days,	
          to_date: DateTime.now,	
          reason: 'ajdhjasdh',
          leave_type: 'paid' 
        } 
      }
      expect(Leave.all.count).to eq(leaves_count)
    end

    it 'should not  create leave by Employee as no authorised employee present' do 
      sign_out(@user)
      leaves_count = Leave.all.count       
      post :create, params: {
        leave: {
          status: 'Pending'	,
          from_date: DateTime.now - 3.days,	
          to_date: DateTime.now,	
          reason: 'ajdhjasdh',
          leave_type: 'paid' 
        } 
      }
      expect(Leave.all.count).to eq(leaves_count)
    end
  end

end