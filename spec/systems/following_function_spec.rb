require 'rails_helper'

RSpec.describe 'following_function', type: :system do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user_a.email
    fill_in 'パスワード', with: user_a.password
    click_button 'ログイン'
    visit user_path(user_b.id)
  end

  context 'with standard way' do
    it 'follows & unfollows' do
      expect{click_button 'フォローする'}.to change{ user_a.following.count }.by(1).and change{ user_b.followers.count }.by(1)
      expect{click_button 'フォローを解除する'}.to change{ user_a.following.count }.by(-1).and change{ user_b.followers.count }.by(-1)
    end
  end

  # context 'with Ajax' do
  #   it 'follows & unfollows', js: true do
  #     expect{click_button 'フォローする'}.to change{ user_a.following.count }.by(1).and change{ user_b.followers.count }.by(1)
  #     expect{click_button 'フォローを解除する'}.to change{ user_a.following.count }.by(-1).and change{ user_b.followers.count }.by(-1)
  #   end
  # end
end
