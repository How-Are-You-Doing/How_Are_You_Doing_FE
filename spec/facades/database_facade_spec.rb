require 'rails_helper'

RSpec.describe DatabaseFacade do
  describe 'class methods' do
    describe '#pending_requests' do
      let(:api_response) { { data: [] } }

      before :each do
        stub_request(:get, "http://localhost:5000/api/v2/users/followers?request_status=pending&user=19023306").
          to_return(status: 200, body: api_response.to_json, headers: {})

        user_google_id = "19023306"
        # VCR.use_cassette('pending_requests') do
        @pending_incoming_requests = DatabaseFacade.pending_requests(user_google_id)
        # end
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

        it 'returns an array of User objects' do
          expect(@pending_incoming_requests).to be_an(Array)
          expect(@pending_incoming_requests.first).to be_a(UserPoro)
        end
      end

      context 'when the user has no pending requests' do
        let(:api_response) { { data: [] } }

        it 'returns an empty array' do
          user_google_id = "19023306"
          VCR.use_cassette('no_pending_requests') do
            @pending_incoming_requests = DatabaseFacade.pending_requests(user_google_id)
          end
          expect(@pending_incoming_requests).to eq([])
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

