require 'rails_helper'

RSpec.describe 'like_function', type: :system, js: true do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:ticket) { create(:ticket, user: user_b) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログイン'
  end

  context 'when click like button' do
    it 'increases like count of ticket by 1' do
      visit ticket_path(ticket.id)
      expect do
        find(".like").click
        wait_for_ajax
      end.to change { ticket.likes.count }.by(1)
    end
  end

  context 'when click like button again' do
    it 'reduces like count of ticket by -1' do
      ticket.like(user_a)
      visit ticket_path(ticket.id)
      expect do
        find(".like").click
        wait_for_ajax
      end.to change { ticket.likes.count }.by(-1)
    end
  end
end
