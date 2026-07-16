require 'rails_helper'

RSpec.describe 'POST /api/v1/auth/sign_in', type: :request do
  let!(:user) { create(:user, username: 'testuser', password: '123456') }

  it 'authenticates with valid username and password' do
    post '/api/v1/auth/sign_in', params: { username: 'testuser', password: '123456' }
    expect(response).to have_http_status(:ok)
    expect(json['status']).to eq('success')
    expect(json['user']['username']).to eq('testuser')
    expect(json['token']).to be_present
  end

  it 'rejects invalid password' do
    post '/api/v1/auth/sign_in', params: { username: 'testuser', password: 'wrong' }
    expect(response).to have_http_status(:unauthorized)
    expect(json['message']).to eq('Usuario o contraseña inválidos')
  end

  it 'rejects non-existent username' do
    post '/api/v1/auth/sign_in', params: { username: 'nobody', password: '123456' }
    expect(response).to have_http_status(:unauthorized)
    expect(json['message']).to eq('Usuario o contraseña inválidos')
  end

  it 'rejects suspended user' do
    user.update!(status: 'suspended')
    post '/api/v1/auth/sign_in', params: { username: 'testuser', password: '123456' }
    expect(response).to have_http_status(:unauthorized)
    expect(json['message']).to eq('Usuario suspendido')
  end

  it 'returns user info with expected fields' do
    post '/api/v1/auth/sign_in', params: { username: 'testuser', password: '123456' }
    expect(json['user']).to include('id', 'username', 'email', 'name', 'lastname', 'profile_id', 'permissions')
  end
end

RSpec.describe 'DELETE /api/v1/auth/sign_out', type: :request do
  let!(:user) { create(:user) }

  it 'invalidates token on sign out' do
    delete '/api/v1/auth/sign_out', headers: { 'Authorization' => "Bearer #{user.authentication_token}" }
    expect(response).to have_http_status(:ok)
    expect(json['status']).to eq('success')
  end

  it 'returns error without token' do
    delete '/api/v1/auth/sign_out'
    expect(response).to have_http_status(:unauthorized)
  end
end
