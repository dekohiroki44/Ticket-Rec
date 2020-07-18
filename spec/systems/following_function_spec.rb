require 'rails_helper'

RSpec.describe 'following_function', type: :system, js: true do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログイン'
  end

  context 'when click follow button' do
    it 'increases following count of current user & followers count of target by 1' do
      visit user_path(user_b.id)
      expect do
        click_button 'フォローする'
        wait_for_ajax
      end.to change { user_a.following.count }.by(1).
        and change { user_b.followers.count }.by(1)
    end
  end

  context 'when click unfollow button' do
    it 'reduces following count of current user & followers count of target by -1' do
      user_a.follow(user_b)
      visit user_path(user_b.id)
      expect do
        page.accept_confirm do
          click_button 'フォローしています'
        end
        wait_for_ajax
      end.to change { user_a.following.count }.by(-1).
        and change { user_b.followers.count }.by(-1)
    end
  end
end
