require 'rails_helper'

RSpec.describe DatabaseFacade do
  describe 'class methods' do
    describe '#pending_requests' do
      before :each do
        user_google_id = "19023306"
        VCR.use_cassette('pending_requests') do
          @pending_requests = DatabaseFacade.pending_requests(user_google_id)
        end
      end
      context 'when the user has pending requests' do
        it 'returns an array of User objects' do
          expect(@pending_requests).to be_an(Array)
          expect(@pending_requests.first).to be_a(UserPoro)
        end
      end

      context 'when the user has no pending requests' do
        it 'returns an empty array' do
          user_google_id = "7357151"
          VCR.use_cassette('no_pending_requests') do
            @pending_requests = DatabaseFacade.pending_requests(user_google_id)
          end
          expect(@pending_requests).to eq([])
        end
      end
    end

    describe '#emotions' do
      before :each do
        VCR.use_cassette('emotions') do
          @emotions = DatabaseFacade.emotions
        end
      end
      it 'returns an array of Emotion class objects' do
        expect(@emotions).to be_an(Array)
        expect(@emotions.first).to be_an(Emotion)
      end
    end
  end
end

