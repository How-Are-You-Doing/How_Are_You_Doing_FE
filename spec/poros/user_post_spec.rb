require 'rails_helper'

RSpec.describe UserPost do
  before :each do
    post_data = {
      emotion: 'tired',
      description: 'so so so tire',
      post_status: 'private',
      user_google_id: '12345667'
    }
    @user_post = UserPost.new(post_data)
  end
  describe 'initialization' do
    it 'instantiates as a UserPost object' do
      expect(@user_post).to be_a(UserPost)
    end

    it 'has attributes' do
      expect(@user_post.description).to eq('so so so tire')
      expect(@user_post.emotion).to eq('tired')
      expect(@user_post.post_status).to eq('private')
      expect(@user_post.user_google_id).to eq('12345667')
    end
  end
end