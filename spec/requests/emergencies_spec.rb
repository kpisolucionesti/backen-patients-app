require 'rails_helper'

RSpec.describe 'Emergencies API', type: :request do
  let(:user) { create(:user, permissions: ['emergencia.view', 'emergencia.edit', 'historial.view']) }
  let(:token) { user.authentication_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  before do
    create_list(:emergency, 3)
  end

  describe 'GET /emergencies' do
    it 'returns paginated emergencies' do
      get '/emergencies', params: { page: 1, per_page: 2 }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json['data'].length).to eq(2)
      expect(json['total']).to eq(3)
      expect(json['page']).to eq(1)
      expect(json['per_page']).to eq(2)
    end

    it 'filters by status' do
      Emergency.update_all(status: Emergency::STATUS_ALTA)
      get '/emergencies', params: { status: Emergency::STATUS_ALTA }, headers: headers
      expect(json['data']).to all(have_key('status'))
    end

    it 'requires authentication' do
      get '/emergencies'
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'GET /emergencies/:id' do
    let(:emergency) { Emergency.first }

    it 'returns emergency detail with medical plans' do
      get "/emergencies/#{emergency.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json['id']).to eq(emergency.id)
      expect(json).to have_key('medical_plans')
    end
  end

  describe 'Medical Plans nested under emergency' do
    let(:emergency) { Emergency.first }
    let(:doctor) { create(:doctor) }

    describe 'POST /emergencies/:id/medical_plans' do
      it 'creates a medical plan' do
        post "/emergencies/#{emergency.id}/medical_plans",
          params: { description: 'Paracetamol 500mg cada 8h', indication_type: 'medication', doctor_id: doctor.id },
          headers: headers

        expect(response).to have_http_status(:created)
        expect(json['description']).to eq('Paracetamol 500mg cada 8h')
        expect(json['indication_type']).to eq('medication')
        expect(json['status']).to eq('active')
      end

      it 'requires doctor edit permission' do
        user.update!(permissions: ['emergencia.view'])
        user.reload
        post "/emergencies/#{emergency.id}/medical_plans",
          params: { description: 'Test', indication_type: 'medication' },
          headers: headers

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'GET /emergencies/:id/medical_plans' do
      let!(:plan) { create(:medical_plan, emergency: emergency, doctor: doctor) }

      it 'lists medical plans' do
        get "/emergencies/#{emergency.id}/medical_plans", headers: headers
        expect(response).to have_http_status(:ok)
        expect(json.length).to eq(1)
        expect(json[0]['description']).to eq(plan.description)
      end
    end

    describe 'DELETE /emergencies/:id/medical_plans/:id' do
      let!(:plan) { create(:medical_plan, emergency: emergency) }

      it 'deletes a medical plan' do
        delete "/emergencies/#{emergency.id}/medical_plans/#{plan.id}", headers: headers
        expect(response).to have_http_status(:no_content)
        expect(MedicalPlan.find_by(id: plan.id)).to be_nil
      end
    end
  end
end
