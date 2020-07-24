require 'rails_helper'

describe 'search_function', type: :system do
  let(:user_a) { create(:user, name: 'word1') }
  let(:user_b) { create(:user) }
  let!(:ticket_a) { create(:ticket, user: user_a, date: DateTime.current - 1.day, name: 'word2', done: true) }
  let!(:ticket_b) { create(:ticket, user: user_b, date: DateTime.current + 1.day, performer: 'word3') }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログイン'
  end

  context 'when nothing is entered' do
    it 'shows all users & tickets' do
      within '#searchbar' do
        fill_in 'date', with: ''
        click_button '検索'
      end
      expect(all('.user-partial').size).to eq User.all.count
      expect(all('.ticket-partial').size).to eq Ticket.all.count
    end
  end

  context 'when text field is entered' do
    it 'shows users & tickets containing word' do
      within '#searchbar' do
        fill_in 'word', with: 'word'
        fill_in 'date', with: ''
        click_button '検索'
      end
      expect(all('.user-partial').size).to eq 1
      expect(all('.ticket-partial').size).to eq 2
    end
  end

  context 'when date field is entered' do
    it 'shows users & tickets for the date' do
      within '#searchbar' do
        fill_in 'word', with: ''
        fill_in 'date', with: Date.tomorrow
        click_button '検索'
      end
      within '.timeline' do
        expect(page).to have_content ticket_b.name
        expect(page).to have_content ticket_b.user.name
        expect(page).not_to have_content ticket_a.name
        expect(page).not_to have_content ticket_a.user.name
      end
    end
  end
end
