require 'rails_helper'

describe 'tickets_page', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:self_ticket) { create(:ticket, user: user, name: "イベント1", performer: "アーティスト1") }
  let(:other_ticket) { create(:ticket, user: other_user, name: "イベント2", performer: "アーティスト2") }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    visit ticket_path(self_ticket.id)
  end

  it 'displays correct contents' do
    expect(page).to have_title "#{self_ticket.name} - Ticket Rec"
    expect(page).to have_content self_ticket.name
    expect(page).to have_content self_ticket.performer
  end

  context 'on self ticket' do
    it 'displays edit & delete link' do
      expect(page).to have_link '編集', href: edit_ticket_path(self_ticket.id)
      expect(page).to have_link '削除', href: ticket_path(self_ticket.id)
    end
  end

  context 'on other user ticket' do
    it 'dose not displays edit & delete link' do
      visit ticket_path(other_ticket.id)
      expect(page).not_to have_link '編集', href: edit_ticket_path(other_ticket.id)
      expect(page).not_to have_link '削除', href: ticket_path(other_ticket.id)
    end
  end
end
