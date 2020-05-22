require 'rails_helper'

RSpec.describe 'products_page', type: :system do
  describe "GET #home" do
    it "returns http success" do
      visit root_path
      expect(page).to have_link '新規登録', href: new_user_registration_path
      expect(page).to have_link 'ログイン', href: new_user_session_path
    end
  end
end
