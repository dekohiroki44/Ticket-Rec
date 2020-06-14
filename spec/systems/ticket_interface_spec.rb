require 'rails_helper'

describe 'microposts_interface', type: :system do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }

  before do
    visit login_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    click_link '書き込む'
  end
  it 'is invlid with wrong input' do
    expect{ 
    click_button '投稿する'
    }.to_not change(Ticket, :count)
    expect(page).to have_css '#error_explanation'
  end
  it 'is valid with valid post' do
    expect{ 
    attach_file "#{Rails.root}/public/images/kitten.jpg"
    click_button '投稿する'
    }.to change{ Micropost.count }.by(1)
    expect(current_path).to eq root_path
    expect(page).to have_selector("img[src$='kitten.jpg']")
  end
  it 'is valid delete a micropost' do
    visit root_path
    expect(page).to have_selector("img[src$='kitten.jpg']") 
    click_link '削除' 
    page.accept_confirm
    expect(page).to_not have_selector("img[src$='kitten.jpg']")
  end
end