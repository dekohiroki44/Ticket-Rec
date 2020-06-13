require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket) }
  let(:like) { build(:like, user_id: user.id, ticket_id: ticket.id) }

  it 'is valid with correct info' do
    expect(like).to be_valid
  end
  it 'is invalid without user_id' do
    like.user_id = nil
    expect(like).to be_invalid
  end
  it 'is invalid without ticket_id' do
    like.ticket_id = nil
    expect(like).to be_invalid
  end

  describe 'like method' do
    it 'created like by like and unlike a ticket' do
      expect(ticket.like?(user)).to be_falsey
      ticket.like(user)
      expect(ticket.like?(user)).to be_truthy
      ticket.unlike(user)
      expect(ticket.like?(user)).to be_falsey
    end
  end
end
