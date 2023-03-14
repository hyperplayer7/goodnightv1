require 'rails_helper'
RSpec.describe Api::V1::SleepsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:user) { create(:user) }
      let(:sleep_params) { attributes_for(:sleep_record, user_id: user.id) }

      it 'creates a new sleep record' do
        expect do
          post :create, params: sleep_params
        end.to change(SleepRecord, :count).by(1)
      end

      it 'returns a list of sleep records for the user' do
        post :create, params: sleep_params
        expect(response).to have_http_status(:created)
        expect(response.body).to include(user.sleep_records.to_json)
      end
    end
  end

  describe 'POST #follow' do
    context 'with valid parameters' do
      let(:fan) { create(:user) }
      let(:follow_user) { create(:user) }

      it 'creates a follow request' do
        expect do
          post :follow, params: { id: follow_user.id, user_id: fan.id }
        end.to change(fan.following, :count).by(1)
      end

      it 'accepts a follow request' do
        fan.send_follow_request_to(follow_user) unless fan.following?(follow_user)
        follow_user.accept_follow_request_of(fan)
        post :follow, params: { id: follow_user.id, user_id: fan.id }
        expect(fan.following?(follow_user)).to be true
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("You are now following user #{follow_user.id}")
      end
    end

    context 'with invalid parameters' do
      let(:fan) { create(:user) }
      let(:follow_user) { create(:user) }

      it 'returns an error message if user does not exist' do
        post :follow, params: { id: 100, user_id: fan.id }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('User does not exist')
      end
    end
  end

  describe 'POST #unfollow' do
    let!(:user) { create(:user) }
    let!(:fan) { create(:user) }
    let!(:unfollow_user) { create(:user) }

    context 'when fan and unfollow user exist' do
      before do
        fan.unfollow(unfollow_user)
        post :unfollow, params: { id: unfollow_user.id, user_id: fan.id }
      end

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'unfollows the user' do
        expect(fan.following?(unfollow_user)).to eq(false)
      end

      it 'returns the correct message' do
        expect(JSON.parse(response.body)['message']).to eq("You are no longer following user #{unfollow_user.id}")
      end
    end

    context 'when fan or unfollow user does not exist' do
      before { post :unfollow, params: { id: 123, user_id: 456 } }

      it 'returns http unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns the correct message' do
        expect(JSON.parse(response.body)['message']).to eq('User does not exist')
      end
    end
  end

  describe '#sleep_records' do
    let(:user) { create(:user) }
    let(:friend1) { create(:user) }
    let(:friend2) { create(:user) }

    before do
      start1 = Faker::Time.between(from: 1.week.ago, to: DateTime.now)
      create(:sleep_record, user: friend1, start_time: start1, end_time: start1 + rand(1..10).hours)

      start2 = Faker::Time.between(from: 1.week.ago, to: DateTime.now)
      create(:sleep_record, user: friend1, start_time: start2, end_time: start2 + rand(1..10).hours)

      start3 = Faker::Time.between(from: 1.week.ago, to: DateTime.now)
      create(:sleep_record, user: friend2, start_time: start3, end_time: start3 + 20.hours)

      start4 = Faker::Time.between(from: 1.week.ago, to: DateTime.now)
      create(:sleep_record, user: friend2, start_time: start4, end_time: start4 + rand(1..10).hours)

      start5 = Faker::Time.between(from: 1.week.ago, to: DateTime.now)
      create(:sleep_record, user: friend2, start_time: start5, end_time: start5 + rand(1..10).hours)

      # user.follow(friend1)
      user.send_follow_request_to(friend1) unless user.following?(friend1)
      friend1.accept_follow_request_of(user)

      # user.follow(friend2)
      user.send_follow_request_to(friend2) unless user.following?(friend2)
      friend2.accept_follow_request_of(user)
    end

    it "returns sleep records of the user's friends within the last week ordered by length of sleep" do
      get :sleep_records, params: { id: user.id }
      expect(response).to have_http_status(:success)
      parsed_body = JSON.parse(response.body)
      puts parsed_body.to_s
      expect(parsed_body.first['start_time'].to_json).to eq(friend2.sleep_records.first.start_time.to_json)
      expect(parsed_body.first['end_time'].to_json).to eq(friend2.sleep_records.first.end_time.to_json)
    end

    context 'when user is not found' do
      it 'returns an empty array' do
        get :sleep_records, params: { id: 'nonexistent' }
        expect(response).to have_http_status(:success)
        expect(response.body).to eq([].to_json)
      end
    end
  end
end
