require 'rails_helper'

RSpec.describe "tickets", type: :request do
  let(:user) { create(:user) }
  let(:otheruser) { create(:user, name: 'otheruser', email: 'other@example.com') }
  let!(:ticket) { create(:ticket, user: user) }

  context 'when creating without log in' do
    it 'redirect to new_user_session_path' do
      expect{ post tickets_path params: { ticket: { date: DateTime.current } } }.to_not change(Ticket, :count)
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when editing without log in' do   
    it 'redirect to new_user_session_path' do
      get edit_ticket_path(ticket)
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when updating without log in' do
    it 'redirect to new_user_session_path' do
      patch ticket_path(ticket)
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when deleting without log in' do
    it 'redirect to new_user_session_path' do
      expect{ delete ticket_path(ticket) }.to_not change(Ticket, :count)
      expect(response).to redirect_to new_user_session_path
    end
  end

  context 'when deleting with log in as wrong user' do
    it 'redirect to new_user_session_path' do
      log_in_as(otheruser)
      expect{ delete ticket_path(ticket) }.to_not change(Ticket, :count)
      expect(response).to redirect_to new_user_session_path
    end
  end
end
