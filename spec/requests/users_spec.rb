require 'rails_helper'

describe 'User', type: :request do
  describe 'GET /users' do
    before do
      FactoryBot.create(:user, name: 'friendly user 1', username: 'user1', password: '12345678')
      FactoryBot.create(:user, name: 'friendly user 2', username: 'user2', password: '12345678')
    end

    it 'returns all the users' do
      get '/api/v1/users'

      expect(response).to have_http_status(:success)
      expect(response_body['data'].size).to eq(2)
    end

    it 'returns single user' do
      get '/api/v1/users/1'

      expect(response).to have_http_status(:success)
      expect(response_body.size).to eq(1)
    end

    it 'does not return single user' do
      get '/api/v1/users/100'

      expect(response).to have_http_status(:not_found)
      expect(response_body).to eq({
          'message' => 'user not found'
      })
    end
  end

  describe 'POST /users/register' do
    it 'registers a new user' do
      post '/api/v1/users/register', params: {name: 'friend 1', username: 'cooldude', password: 'dudecool'}

      expect(response).to have_http_status(:created)
      expect(response_body.size).to eq(6)
      expect(response_body['name']).to eq('friend 1')
      expect(response_body['username']).to eq('cooldude')
      expect(BCrypt::Password.new(response_body['password_digest']) == 'dudecool').to be true
    end

    it 'returns error when name is not provided'
    it 'returns error when username is not provided'
    it 'returns error when password is not provided'

    it 'returns error when username already exists'
  end

  describe 'POST /users/login' do
    
  end
end