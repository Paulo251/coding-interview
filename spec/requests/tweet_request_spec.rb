require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  let!(:user) { create(:user) }
  let!(:tweets) { create_list(:tweet, 25, user: user) }

  describe "GET /tweets" do
    it "returns paginated tweets with cursor" do
      get tweets_path

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['tweets'].count).to eq(20)
      expect(json_response['next_cursor']).to be_present
      expect(json_response['has_more']).to be true
    end

    it "respects cursor parameter" do
      get tweets_path, params: { cursor: tweets[19].created_at.to_i }

      json_response = JSON.parse(response.body)
      expect(json_response['tweets'].count).to eq(5)
      expect(json_response['has_more']).to be false
    end
  end

  describe "GET /users/:user_id/tweets" do
    it "returns user-specific tweets with pagination" do
      get user_tweets_path(user_id: user.id)

      expect(response).to have_http_status(:success)
      json_response = JSON.parse(response.body)

      expect(json_response['tweets'].count).to eq(20)
      expect(json_response['next_cursor']).to be_present
    end
  end

end
