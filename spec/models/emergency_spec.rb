require 'rails_helper'

RSpec.describe Emergency, type: :model do
  describe 'associations' do
    it { should belong_to(:patient) }
    it { should belong_to(:created_by).class_name('User').optional }
    it { should have_many(:emergency_doctors).dependent(:destroy) }
    it { should have_many(:doctors).through(:emergency_doctors) }
    it { should have_many(:medical_plans).dependent(:destroy) }
  end

  describe 'status constants' do
    it 'defines ATENDIDO as 1' do
      expect(Emergency::STATUS_ATENDIDO).to eq(1)
    end

    it 'defines ALTA as 2' do
      expect(Emergency::STATUS_ALTA).to eq(2)
    end

    it 'defines INGRESADO as 3' do
      expect(Emergency::STATUS_INGRESADO).to eq(3)
    end
  end

  describe '#primary_doctor' do
    it 'returns the doctor marked as primary' do
      emergency = create(:emergency)
      primary_doc = emergency.emergency_doctors.find_by(primary: true)&.doctor
      expect(emergency.primary_doctor).to eq(primary_doc)
    end
  end

  describe '#consulting_doctors' do
    it 'returns non-primary doctors' do
      emergency = create(:emergency)
      doc1 = create(:doctor)
      create(:emergency_doctor, emergency: emergency, doctor: doc1, primary: false)
      expect(emergency.consulting_doctors).to include(doc1)
    end
  end
end
