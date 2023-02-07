require 'rails_helper'

RSpec.describe TaxDeductionsController, type: :controller do
  describe 'GET #index'do
    before do      
      @tax_deduction = create(:tax_deduction)
      @tax_deductions = TaxDeduction.all
    end
    context 'test' do
      it 'display a list of all Tax Deductions' do
        @user = create(:user, type: 'Admin')
        sign_in(@user)
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'test for Employee' do
      it 'display a list of all Tax Deductions' do
        @user = create(:employee)
        sign_in(@user)
        get :index
        expect(response).to render_template(:index)
      end
    end
  end 

  describe 'GET #show'do
    before do 
      @user = create(:user, type: 'Admin')
      sign_in(@user)     
      @tax_deduction = create(:tax_deduction)
    end
    context 'Tax deductions show' do
      it "display  employee's tax deductions details to the admin" do
        get :show, params: {id: @tax_deduction.id }
        expect(response.status).to eq(200) 
      end
      
      it "display  employee's tax deductions  details without login" do 
        sign_out(@user)             
        get :show, params: {id: @tax_deduction.id }
        expect(response.status).to eq(302)
      end      
    end
  
    context 'Tax deductions show to specific employee' do
      before do 
        @user = create(:employee)
        sign_in(@user)     
        @tax_deduction = create(:tax_deduction, employee_id: @user.id)
      end
      it "display  employee's tax deductions details to the employee" do
        get :show, params: {id: @tax_deduction.id }
        expect(response.status).to eq(200) 
      end    
  
      it "Not to display employee's tax deduction details to other employee" do
        sign_out(@user)       
        get :show, params: {id: @tax_deduction.id }
        expect(response.status).to eq(302) 
      end
    end
  end


  context 'PUT update' do    
    before do      
      @tax_deduction = create(:tax_deduction)
    end
    it 'should update tax deduction by Admin' do  
      @user = create(:employee)
      sign_in(@user) 
      arr = ['NPS', 'Non-NPS']   
      put :update, params: {
        tax_deduction: {          
          tax_type:  arr.sample,
          ammount: 70000,
          employee_id: @user.id,
          financial_year: Date.today.year
        }, id: @tax_deduction.id  
      }
      expect(@tax_deduction.reload.ammount).to eq(70000)
    end
  end

  context 'DELETE destroy' do   
    before do      
      @user = create(:employee)
      @tax_deduction = create(:tax_deduction)
    end
    it 'should delete the Tax deduction' do 
      tax_deductions_count = TaxDeduction.all.count
      sign_in(@user)
      delete :destroy, params: { id: @tax_deduction.id }
      expect(TaxDeduction.all.count).to eq(tax_deductions_count-1)
    end
    it 'should not delete the tax deduction' do
      tax_deductions_count = TaxDeduction.all.count
      @tax_deduction = create(:tax_deduction) 
      delete :destroy, params: { id: @tax_deduction.id } 
      expect(TaxDeduction.all.count).to eq(tax_deductions_count)
    end
  end

  context 'Post create' do    
    before do 
      @user = create(:employee)
      sign_in(@user)       
    end
    it 'should create Tax deduction by Employee' do 
      tax_deductions_count = TaxDeduction.all.count       
      arr = ['NPS', 'Non-NPS']   
      post :create, params: {
        tax_deduction: {          
          tax_type:  arr.sample,
          ammount: 70000,
          employee_id: @user.id,
          financial_year: Date.today.year
        } 
      }
      expect(TaxDeduction.all.count).to eq(tax_deductions_count + 1)
    end

    it 'should not  create tax deduction by employee as all attributes not provided' do 
      tax_deductions_count = TaxDeduction.all.count       
      arr = ['NPS', 'Non-NPS']        
      post :create, params: {
        tax_deduction: {          
          tax_type:  arr.sample,          
          financial_year: Date.today.year
        } 
      }
      expect(TaxDeduction.all.count).to eq(tax_deductions_count)
    end
  
    it 'should not  create tax deduction for unauthorised user' do 
      tax_deductions_count = TaxDeduction.all.count       
      arr = ['NPS', 'Non-NPS'] 
      sign_out(@user)
      post :create, params: {
        tax_deduction: {          
          tax_type:  arr.sample,          
          financial_year: Date.today.year
        } 
      }
      expect(TaxDeduction.all.count).to eq(tax_deductions_count)
    end
  end
end