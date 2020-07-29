require 'rails_helper'

describe 'users_edit', type: :system do
  let(:user) { create(:user) }

  context 'when login as a normal user' do
    before do
      visit new_user_session_path
      fill_in 'Eメール', with: user.email
      fill_in 'パスワード', with: user.password
      click_button 'ログイン'
    end

    it 'fails witout current password' do
      visit edit_user_registration_path(user)
      fill_in '名前', with: ''
      fill_in 'Eメール', with: ''
      click_button '更新'
      expect(user.reload.name).to eq user.name
      expect(page).to have_selector('.alert', text: '現在のパスワードを入力してください')
    end

    it 'succeeds with current password ' do
      visit edit_user_registration_path(user)
      fill_in '名前', with: 'Foo Bar'
      fill_in 'Eメール', with: 'foo@bar.com'
      fill_in '現在のパスワード', with: user.password
      click_button '更新'
      expect(page).to have_selector('.alert', text: 'アカウント情報を変更しました。')
      expect(current_path).to eq root_path
      expect(user.reload.name).to eq 'Foo Bar'
      expect(user.reload.email).to eq 'foo@bar.com'
    end
  end

  context 'when login as a guest user' do
    before do
      visit root_path
      within '#sidebar-wrapper' do
        click_link 'ゲストログイン（閲覧用）'
      end
    end

    it 'cannot be edited' do
      visit edit_user_registration_path(user)
      fill_in '名前', with: 'Foo Bar'
      fill_in 'Eメール', with: 'foo@bar.com'
      fill_in '現在のパスワード', with: user.password
      click_button '更新'
      expect(page).to have_selector('.alert', text: 'ゲストユーザーの編集・削除はできません。')
      expect(current_path).to eq root_path
      expect(user.reload.name).not_to eq 'Foo Bar'
      expect(user.reload.email).not_to eq 'foo@bar.com'
    end
  end
end
