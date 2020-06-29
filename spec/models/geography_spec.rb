require 'rails_helper'

RSpec.describe Geography, type: :model do
  let(:geography) { build(:geography)}

  it 'is valid' do
    expect(geography).to be_valid
  end
end
