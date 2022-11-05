require 'rails_helper'

RSpec.describe UserFacade do
  describe 'class methods' do
    describe '#create' do
      it 'can create a new user in the backend db' do
        # VCR.turn_off!
        # WebMock.allow_net_connect!
        user = create(:user, name: 'joe', google_id: '123456789', email: 'joe@joe.joe')
        VCR.use_cassette('successful_user_creation') do
          UserFacade.create(user)
        end
        VCR.use_cassette('user_creation_lookup') do
          expect(UserFacade.search(user.email).google_id).to eq(user.google_id)
        end
        # VCR.turn_on!
        # WebMock.disable_net_connect!
      end
    end
  end
end