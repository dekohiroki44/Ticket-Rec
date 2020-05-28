require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let(:user_a) { create(:user) }
  let(:user_b) { create(:user) }
  let(:relationship) { build(:relationship, follower_id: user_a.id, followed_id: user_b.id)}

  it 'is valid with valid info' do
    expect(relationship).to be_valid 
  end

  it 'is invalid without follower_id' do
    relationship.follower_id = nil
    expect(relationship).to be_invalid 
  end

  it 'is invalid without followed_id' do
    relationship.followed_id = nil
    expect(relationship).to be_invalid 
  end
  
  it 'is created by follow and unfollow a user' do
    expect(user_a.following?(user_b)).to be_falsey
    user_a.follow(user_b)
    expect(user_a.following?(user_b)).to be_truthy
    expect(user_b.followers.include?(user_a)).to be_truthy
    user_a.unfollow(user_b)
    expect(user_a.following?(user_b)).to be_falsey
  end
end
