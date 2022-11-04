require 'rails_helper'

RSpec.describe DatabaseService do
  describe 'class methods' do
    describe '#pending_requests' do
      before :each do
        user_google_id = 19023306
        VCR.use_cassette('pending_requests') do
          @pending_requests = DatabaseService.pending_requests(user_google_id)
        end
      end
      it 'returns a hash' do
        expect(@pending_requests).to be_a(Hash)
      end
      context 'when the user has pending requests' do
        it 'returns an array of hashes' do
          expect(@pending_requests[:data]).to be_an(Array)
        end

        it 'inside array, is a hash with user attributes' do
          expect(@pending_requests[:data].first[:attributes][:name]).to be_a(String)
          expect(@pending_requests[:data].first[:attributes][:email]).to be_a(String)
          expect(@pending_requests[:data].first[:id]).to be_an(String)
        end
      end

      context 'when the user has no pending requests' do
        it 'returns an empty array' do
          user_google_id = 7357151
          VCR.use_cassette('no_pending_requests') do
            @pending_requests = DatabaseService.pending_requests(user_google_id)
          end
          expect(@pending_requests[:data]).to eq([])
        end
      end
    end
  end
end