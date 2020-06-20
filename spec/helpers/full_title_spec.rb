require 'rails_helper'

RSpec.describe 'full_title', type: :helper do
  include ApplicationHelper
  it 'returns full title' do
    expect(full_title(nil)).to eq 'Ticket Rec'
    expect(full_title(' ')).to eq 'Ticket Rec'
    expect(full_title('page_title')).to eq 'page_title - Ticket Rec'
  end
end
