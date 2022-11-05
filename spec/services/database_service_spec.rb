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

    describe '#emotions' do
      before :each do
        VCR.use_cassette('emotions') do
          @emotions = DatabaseService.emotions
        end
      end
      describe 'returns a list of emotions with their definitions' do
        it 'returns a hash' do
          expect(@emotions).to be_a(Hash)
        end
        it 'returns an array of hashes' do
          expect(@emotions[:data]).to be_an(Array)
        end
        it 'inside array, is a hash with emotion attributes' do
          expect(@emotions[:data].first[:attributes][:emotion]).to be_a(String)
          expect(@emotions[:data].first[:attributes][:definition]).to be_a(String)
          expect(@emotions[:data].first[:id]).to be_an(String)
        end
      end
    end
  end
end