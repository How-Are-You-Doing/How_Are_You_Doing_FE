require 'rails_helper'

RSpec.describe Friendship do
  before :each do
    friend_data = { id: 1, 
                  friendship_id: 4, 
                  type: 'friend_follower', 
                  attributes: { name: 'Ricky LaFleur', 
                                email: 'igotmy@grade10.com', 
                                google_id: '19023306',
                                request_status: 'accepted'} }
    @friendship = Friendship.new(friend_data)
  end
  describe 'initialization' do
    it 'instantiates as a Friendship object' do
      expect(@friendship).to be_a(Friendship)
    end

    it 'has attributes' do
      expect(@friendship.user_id).to eq(1)
      expect(@friendship.friend_name).to eq('Ricky LaFleur')
      expect(@friendship.friend_email).to eq('igotmy@grade10.com')
      expect(@friendship.friend_google_id).to eq('19023306')
      expect(@friendship.request_status).to eq('accepted')
      expect(@friendship.friendship_id).to eq(4)
    end
  end
end