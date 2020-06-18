require 'rails_helper'

RSpec.describe "likes", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let(:ticket) { create(:ticket, user: other_user) }

  context 'when not logged in' do
    it 'is redirect require log in at like' do
      expect{ post likes_path }.to_not change(Like, :count)
      expect(response).to redirect_to new_user_session_path
    end

    it 'is redirect require log in at unlike' do
      like = Like.create(user_id: user.id, ticket_id: ticket.id)
      expect{ delete like_path(like) }.to_not change(Like, :count)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
