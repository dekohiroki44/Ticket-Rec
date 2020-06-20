require 'rails_helper'

describe 'signup', type: :system do
  before do
    visit new_user_registration_path
  end

  it 'is invalid with wrong input' do
    expect do
      fill_in '名前', with: ''
      fill_in 'Eメール', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード（確認用）', with: ''
      click_button 'アカウント登録'
    end.not_to change(User, :count)
    expect(page).to have_css '.alert'
  end

  it 'is valid with correct input' do
    expect do
      fill_in '名前', with: 'testuser'
      fill_in 'Eメール', with: 'test1@example.com'
      fill_in 'パスワード', with: 'password'
      fill_in 'パスワード（確認用）', with: 'password'
      check 'tos'
      click_button 'アカウント登録'
    end.to change(User, :count).by(1)
    user = User.last
    expect(current_path).to eq root_path(user)
    expect(page).to have_content 'Ticket Recへようこそ！'
    expect(page).to have_link user.name, href: user_path(user)
    expect(page).to have_link '皆んなのチケット', href: tickets_path
    expect(page).to have_link '書き込む', href: new_ticket_path
    expect(page).to have_link '通知', href: notifications_path
    expect(page).to have_link 'ログアウト', href: destroy_user_session_path
    expect(page).to have_link 'Ticket Recについて', href: about_path
    expect(page).not_to have_link 'ログイン', href: new_user_session_path
  end
end
