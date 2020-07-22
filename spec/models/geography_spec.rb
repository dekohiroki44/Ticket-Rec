require 'rails_helper'

RSpec.describe Geography, type: :model do
  let(:geography) { build(:geography) }

  it 'is valid' do
    expect(geography).to be_valid
  end

  it 'is invalid with not unique name' do
    duplicate_geography = geography.dup
    duplicate_geography.name = geography.name.upcase
    geography.save!
    expect(duplicate_geography).to be_invalid
  end
end
