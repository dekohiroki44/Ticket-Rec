require 'rails_helper'

RSpec.describe "relationships", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context 'when not logged in' do
    it 'is redirect require log in at create' do
      expect { post relationships_path }.not_to change(Relationship, :count)
      expect(response).to redirect_to new_user_session_path
    end

    it 'is redirect require log in at destroy' do
      relationship = Relationship.create(followed_id: user.id, follower_id: other_user.id)
      expect { delete relationship_path(relationship) }.not_to change(Relationship, :count)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
