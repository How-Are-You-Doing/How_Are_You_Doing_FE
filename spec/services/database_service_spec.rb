require 'rails_helper'

RSpec.describe DatabaseService do
  describe 'class methods' do
    describe '#users_pending_requests' do
      let(:api_response) { { data: [] } }

      before :each do
        #below code commented out for now until endpoint is made, and we can reintroduce VCR
        user_google_id = '19023306'
        # VCR.use_cassette('pending_requests') do
        #   @pending_requests = DatabaseService.users_pending_requests(user_google_id)
        stub_request(:get, "http://localhost:5000/api/v2/users/followers?request_status=pending").
          to_return(status: 200, body: api_response.to_json, headers: {})

        @pending_requests = DatabaseService.users_pending_requests(user_google_id)
      end

      context 'when the user has pending requests' do
        let(:api_response) do
          { "data":
            [
              {
                "id": "1",
                "type": "user",
                "attributes": { "name": "Melissa",
                  "email": "melissa@mail.com",
                  "google_id": "9999999" }
              },
              {
                "id": "2",
                "type": "user",
                "attributes": { "name": "Joseph",
                  "email": "joe@mail.com",
                  "google_id": "9999999" }
              },
              {
                "id": "3",
                "type": "user",
                "attributes": { "name": "Josephine",
                  "email": "josephine@mail.com",
                  "google_id": "9999999" }
              },
            ]
          }
        end

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
        let(:api_response) { { data: [] } }

        it 'returns an empty array' do
          #commented out until endpoint up and running
          user_google_id = '7357151'
          # VCR.use_cassette('no_pending_requests') do
          @empty_pending_requests = DatabaseService.users_pending_requests(user_google_id)
          expect(@empty_pending_requests[:data]).to eq([])
        end
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
