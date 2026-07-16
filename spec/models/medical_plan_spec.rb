require 'rails_helper'

RSpec.describe MedicalPlan, type: :model do
  describe 'associations' do
    it { should belong_to(:emergency) }
    it { should belong_to(:doctor).optional }
    it { should belong_to(:created_by).class_name('User').optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:description) }
    it { should validate_inclusion_of(:indication_type).in_array(%w[medication procedure image lab general]) }
  end

  describe 'scopes' do
    let!(:emergency) { create(:emergency) }
    let!(:active_plan) { create(:medical_plan, emergency: emergency, status: 'active') }
    let!(:completed_plan) { create(:medical_plan, emergency: emergency, status: 'completed') }

    it 'returns active plans' do
      expect(MedicalPlan.active).to include(active_plan)
      expect(MedicalPlan.active).not_to include(completed_plan)
    end

    it 'returns completed plans' do
      expect(MedicalPlan.completed).to include(completed_plan)
      expect(MedicalPlan.completed).not_to include(active_plan)
    end
  end

  describe 'INDICATION_TYPES' do
    it 'defines 5 types' do
      expect(MedicalPlan::INDICATION_TYPES.keys).to match_array(%i[medication procedure image lab general])
    end
  end
end
