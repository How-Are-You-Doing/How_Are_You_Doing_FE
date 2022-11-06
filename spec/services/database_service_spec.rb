require 'rails_helper'

RSpec.describe DatabaseService do
  describe 'class methods' do
    describe '#pending_requests' do
      before :each do
        user_google_id = '19023306'
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
          user_google_id = '7357151'
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

    describe '#last_post' do
      # TODO Edge cases: user doesn't exist
      context 'the user has one or more posts' do
        before :each do
          VCR.use_cassette('last_post_for_user_19023306') do
            @last_post = DatabaseService.last_post(19023306)
          end
        end
        it 'returns a hash of the last post' do
          expect(@last_post).to be_a(Hash)
        end
        it 'hash has a data key with a hash as its value' do
          expect(@last_post[:data]).to be_a(Hash)
        end

        it 'inside the data keys hash is the post id and a list of attributes' do
          expect(@last_post[:data][:id]).to be_a(String)
          expect(@last_post[:data][:attributes][:emotion]).to be_a(String)
          expect(@last_post[:data][:attributes][:post_status]).to be_a(String)
          expect(@last_post[:data][:attributes][:description]).to be_a(String)
          expect(@last_post[:data][:attributes][:tone]).to be_a(String)
          expect(@last_post[:data][:attributes][:created_at]).to be_a(String)
        end
      end

      context 'the user has no posts' do
        # User with no posts to add to seed in BE
        # user_8 = User.create!(name: "Lonely", email: "noposts@lonely.alone", google_id: "8675310")
        before :each do
          # VCR.use_cassette('no_posts_user_8675310') do
          #   @last_post = DatabaseService.last_post(8675310)
          # end
          response_body = {"data"=>{}}.to_json
          stub_request(:get, "http://localhost:5000/api/v2/posts/last?user=8675310").
            to_return(status: 200, body: response_body, headers: {})
          @last_post = DatabaseService.last_post(8_675_310)
        end
        it 'returns a hash of the last post' do
          expect(@last_post).to be_a(Hash)
        end
        it 'hash has a data key with a hash as its value' do
          expect(@last_post[:data]).to be_a(Hash)
        end

        it 'inside the data keys hash is nothing' do
          expect(@last_post[:data].empty?).to eq(true)
        end
      end
    end
  end
end