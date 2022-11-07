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

    describe '#last_post' do
      # TODO Edge cases: user doesn't exist
      context 'the user has one or more posts' do
        before :each do
          VCR.use_cassette('last_post_for_user_19023306') do
            @last_post = DatabaseFacade.last_post(19023306)
          end
        end
        it 'returns a Post class object' do
          expect(@last_post).to be_a(Post)
        end

        it 'inside the data keys hash is the post id and a list of attributes' do
          expect(@last_post.id).to be_a(String)
          expect(@last_post.emotion).to be_a(String)
          expect(@last_post.post_status).to be_a(String)
          expect(@last_post.description).to be_a(String)
          expect(@last_post.tone).to be_a(String)
          expect(@last_post.created_at).to be_a(DateTime)
        end
      end

      context 'the user has no posts' do
        # User with no posts to add to seed in BE
        # user_8 = User.create!(name: "Lonely", email: "noposts@lonely.alone", google_id: "8675310")
        before :each do
          # VCR.use_cassette('no_posts_user_8675310') do
          #   @last_post = DatabaseFacade.last_post(8675310)
          # end
          response_body = {"data"=>{}}.to_json
          stub_request(:get, "http://localhost:5000/api/v2/posts/last?user=8675310").
            to_return(status: 200, body: response_body, headers: {})
          @last_post = DatabaseFacade.last_post(8_675_310)
        end
        it 'returns a hash of the last post' do
          expect(@last_post).to be_a(Hash)
        end
        it 'inside the data keys hash is nothing' do
          expect(@last_post.empty?).to eq(true)
        end
      end
    end

    describe '#new_post' do
      describe 'creates a new post on the backend and returns that post' do
        before :each do
          post_data = { 
            description: 'so excited for this is a new post to be made by the front end!',
            emotion: 'Grateful',
            post_status: 'personal',
            user_google_id: '8675309'
}
          @user_post = UserPost.new(post_data)
          VCR.use_cassette('successful_post_creation') do
            @new_post = DatabaseFacade.new_post(@user_post)
          end
        end
        it 'returns the post as a Post object with the same attributes' do
          expect(@new_post).to be_a(Post)
          expect(@new_post.description).to eq(@user_post.description)
          expect(@new_post.emotion).to eq(@user_post.emotion)
          expect(@new_post.post_status).to eq(@user_post.post_status)
          expect(@new_post.tone).to be_a(String)
          expect(@new_post.created_at).to be_a(DateTime)
        end
      end
    end
  end
end
