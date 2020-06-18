require 'rails_helper'

describe 'comments_interface', type: :system, js: true do
  let(:user) { create(:user) }
  let(:otheruser) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  it 'is invalid without input' do
    visit ticket_path(ticket.id)
    expect { click_button 'コメントする' }.not_to change(Comment, :count)
  end

  it 'is valid with content' do
    visit ticket_path(ticket.id)
    expect do
      find(".area").set("test")
      click_button 'コメントする'
      expect(page).to have_content 'コメントしました'
    end.to change(Comment, :count).by(1)
  end

  it 'is valid delete self comment' do
    user.comments.create(ticket_id: ticket.id, content: "test")
    visit ticket_path(ticket.id)
    expect do
      page.accept_confirm do
        find(".comment-delete").click
      end
      wait_for_ajax
    end.to change(Comment, :count).by(-1)
  end

  it 'does not show delete link for other users comment' do
    otheruser.comments.create(ticket_id: ticket.id, content: "test")
    visit ticket_path(ticket.id)
    expect(page).not_to have_css ".comment-delete"
  end
end
