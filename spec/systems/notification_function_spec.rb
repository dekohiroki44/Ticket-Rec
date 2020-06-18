require 'rails_helper'

describe 'notification_function', type: :system, js: true do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:ticket) { create(:ticket, user: user_b) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログイン'
  end

  context 'when follow user' do
    it 'shows uncheked count to visited user until visit notifications index' do
      visit user_path(user_b.id)
      click_button 'フォローする'
      within '#sidebar-wrapper' do
        click_link 'ログアウト'
      end
      visit new_user_session_path
      fill_in 'Eメール', with: user_b.email
      fill_in 'パスワード', with: user_b.password
      click_button 'ログイン'
      click_link '1件の未読通知'
      expect(page).to have_link '通知'
      expect(page).not_to have_link '1件の未読通知'
    end
  end

  context 'when like ticket' do
    it 'shows uncheked count to visited user until visit notifications index' do
      visit ticket_path(ticket.id)
      find(".like").click
      within '#sidebar-wrapper' do
        click_link 'ログアウト'
      end
      visit new_user_session_path
      fill_in 'Eメール', with: user_b.email
      fill_in 'パスワード', with: user_b.password
      click_button 'ログイン'
      click_link '1件の未読通知'
      expect(page).to have_link '通知'
      expect(page).not_to have_link '1件の未読通知'
    end
  end

  context 'when post comment' do
    it 'shows uncheked count to visited user until visit notifications index' do
      visit ticket_path(ticket.id)
      find(".area").set("test")
      click_button 'コメントする'
      within '#sidebar-wrapper' do
        click_link 'ログアウト'
      end
      visit new_user_session_path
      fill_in 'Eメール', with: user_b.email
      fill_in 'パスワード', with: user_b.password
      click_button 'ログイン'
      click_link '1件の未読通知'
      expect(page).to have_link '通知'
      expect(page).not_to have_link '1件の未読通知'
    end
  end
end
