require 'rails_helper'

describe 'following_follwers_pages', type: :system do
  let(:user) { create(:user, email: 'user@example.com') }
  let(:other_user) { create(:user, email: 'other@example.com') }

  before do
    user.follow(other_user)
    other_user.follow(user)
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  context 'when visit following page' do
    before do
      visit following_user_path(user)
    end

    it 'shows following is not empty' do
      expect(user.following).not_to be_empty
    end

    it 'shows count of following' do
      expect(page).to have_content user.following.count
    end

    it 'shows link of following' do
      expect(page).to have_link other_user.name, href: user_path(other_user)
    end
  end

  context 'when visit followers page' do
    before do
      visit followers_user_path(user)
    end

    it 'show followers is not empty' do
      expect(user.followers).not_to be_empty
    end

    it 'shows count of followers' do
      expect(page).to have_content user.followers.count
    end

    it 'shows link of followers' do
      expect(page).to have_link other_user.name, href: user_path(other_user)
    end
  end
end
