require 'rails_helper'

describe 'tickets_interface', type: :system, js: true do
  let(:user) { create(:user) }
  let(:ticket) { create(:ticket, user: user) }

  before do
    visit new_user_session_path
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  it 'is invalid without input' do
    within '#sidebar-wrapper' do
      click_link '書き込む'
    end
    wait_for_css_appear(".modal-dialog", 3) do
      expect { click_button '投稿する' }.not_to change(Ticket, :count)
    end
  end

  it 'is valid with date' do
    within '#sidebar-wrapper' do
      click_link '書き込む'
    end
    wait_for_css_appear(".modal-dialog", 3) do
      expect do
        fill_in '日付', with: DateTime.current
        click_button '投稿する'
        expect(page).to have_content 'チケットを作成しました'
      end.to change(Ticket, :count).by(1)
      expect(current_path).to eq ticket_path(Ticket.order(created_at: "asc").last.id)
    end
  end

  it 'is valid delete a ticket' do
    visit ticket_path(ticket.id)
    expect do
      page.accept_confirm do
        click_link '削除'
      end
      wait_for_ajax
    end.to change(Ticket, :count).by(-1)
  end
end
