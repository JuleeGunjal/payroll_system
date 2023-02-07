require 'rails_helper'

RSpec.describe Salary, type: :model do
  context 'when creating salary ' do
    let(:salary) { build :salary }
    let(:salary1) { build :salary, date: '' }
    it 'should be valid salary with valid parameters' do     
      expect(salary.valid?).to eq(true)
    end
    it 'should not valid salary with invalid parameters' do
      expect(salary1.valid?).to eq(false)
    end
  end
end
