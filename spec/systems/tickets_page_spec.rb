require 'rails_helper'

describe 'tickets_page', type: :system do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:self_ticket) { create(:ticket, user: user, name: "name") }
  let!(:self_ticket_previous) { create(:ticket, user: user, date: self_ticket.date - 1.day, done: true) }
  let!(:self_ticket_next) { create(:ticket, user: user, date: self_ticket.date + 1.day) }
  let(:other_ticket) { create(:ticket, user: other_user) }
  let(:like) { create(:like, user_id: other_user.id, ticket_id: self_ticket.id) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    visit ticket_path(self_ticket.id)
  end

  it 'displays details of the ticket' do
    expect(page).to have_title "#{self_ticket.name} - Ticket Rec"
    expect(page).to have_content self_ticket.user.name
    expect(page).to have_content self_ticket.name
    expect(page).to have_content self_ticket.performer
  end

  it 'displays details of the user who posted' do
    expect(page).to have_content self_ticket.user.name
  end

  it 'changes previous ticket page after click <<' do
    click_link '<<'
    expect(current_path).to eq ticket_path(self_ticket_previous.id)
  end

  it 'changes previous ticket page after click >>' do
    click_link '>>'
    expect(current_path).to eq ticket_path(self_ticket_next.id)
  end

  it 'shows like count' do
    expect(page).to have_content self_ticket.likes.count
  end

  context 'on self ticket' do
    it 'displays edit & delete link' do
      expect(page).to have_link '編集', href: edit_ticket_path(self_ticket.id)
      expect(page).to have_link '削除', href: ticket_path(self_ticket.id)
    end
  end

  context 'on other user ticket' do
    it 'dose not display edit & delete link' do
      visit ticket_path(other_ticket.id)
      expect(page).not_to have_link '編集', href: edit_ticket_path(other_ticket.id)
      expect(page).not_to have_link '削除', href: ticket_path(other_ticket.id)
    end
  end
end
