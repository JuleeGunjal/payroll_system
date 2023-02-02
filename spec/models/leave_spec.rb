require 'rails_helper'

RSpec.describe Leave, type: :model do
  context 'when creating leave ' do
    let(:leave) { build :leave }
    let(:leave1) { build :leave, status: '' }
    it 'should be valid leave with valid parameters' do     
      expect(leave.valid?).to eq(true)
    end
    it 'should not valid leave with invalid parameters' do
      expect(leave1.valid?).to eq(false)
    end
  end
end
