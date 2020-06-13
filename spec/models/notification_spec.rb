require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:ticket) { create(:ticket, user: user_b) }
  let(:comment) { create(:comment, user: user_a, ticket: ticket) }
  let(:notification) { build(:notification, visitor: user_a, visited: user_b) }

  context 'follow' do
    it 'is valid with correct info' do
      notification.action = "follow"
      expect(notification).to be_valid
    end
  end

  context 'like' do
    it 'is valid with correct info' do
      notification.action = "like"
      notification.ticket_id = ticket.id
      expect(notification).to be_valid
    end
  end

  context 'comment' do
    it 'is valid with correct info' do
      notification.action = "comment"
      notification.comment_id = comment.id
      expect(notification).to be_valid
    end
  end
end
