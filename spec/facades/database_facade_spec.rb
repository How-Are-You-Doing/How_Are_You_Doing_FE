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

    describe '#update_post' do
      describe 'updates a users post based on post id' do
        before :each do
          @post_data = {
            description: 'so excited for this is a new post to be made by the front end!',
            emotion: 'Grateful',
            post_status: 'personal',
            user_google_id: '8675309'
          }
          @user_post = UserPost.new(@post_data)
          VCR.use_cassette('successful_post_creation') do
            @new_be_post = DatabaseFacade.new_post(@user_post)
          end
          @updated_data = {
            description: 'so in love with this new post to be made by the front end!',
            emotion: 'Affectionate',
            post_status: 'shared',
            id: @new_be_post.id
          }
        end
        context 'the id matches a post id' do
          it 'returns the updated BE post object' do
            VCR.use_cassette('successful_post_update') do
              @updated_post = DatabaseFacade.update_post(@updated_data)
  
            end

            expect(@updated_post.id).to eq(@new_be_post.id)
            expect(@updated_post.emotion).to eq(@updated_data[:emotion])
            expect(@updated_post.post_status).to eq(@updated_data[:post_status])
            expect(@updated_post.description).to eq(@updated_data[:description])
          end

          context 'not all attributes are being changed' do
            it 'returns the updated BE post with only the changed attributes different' do
              @updated_data = {
                post_status: 'shared',
                id: @new_be_post.id
              }
              VCR.use_cassette('successful_post_partial_update') do
                @updated_post = DatabaseFacade.update_post(@updated_data)
              end

              expect(@updated_post.id).to eq(@new_be_post.id)
              expect(@updated_post.emotion).to eq(@post_data[:emotion])
              expect(@updated_post.post_status).to eq(@updated_data[:post_status])
              expect(@updated_post.description).to eq(@post_data[:description])
            end
          end
        end

        # context 'the id does not match a post id' do
        #   it 'returns a post not found error' do
        #     updated_data = {
        #       post_status: 'public',
        #       id: 'A'
        #     }
        #     VCR.use_cassette('failed_post_update') do
        #       @updated_post = DatabaseService.update_post(updated_data)
        #     end
        #     expect(@updated_post[:error]).to eq("Not Found")
        #   end
        # end
      end
    end

    describe '#lookup_post' do
      describe 'finds the post based on the id passed in' do
        context 'if the id matches an existing post' do
          it 'returns the post as a post object' do
            VCR.use_cassette('find_user_8675309') do
              @user = UserFacade.find_user(8675309)
            end
            @post_data = {
              description: 'so excited for this is a new post to be made by the front end!',
              emotion: 'Grateful',
              post_status: 'personal',
              user_google_id: '8675309'
            }
            @user_post = UserPost.new(@post_data)
            VCR.use_cassette('successful_post_creation') do
              @new_be_post = DatabaseFacade.new_post(@user_post)
            end
            VCR.use_cassette('find_post_by_id') do
              @found_post = DatabaseFacade.lookup_post(@user, @new_be_post.id)
            end
            expect(@found_post).to be_a(Post)
            expect(@found_post.id).to eq(@new_be_post.id)
          end
        end
        context 'if the id doesnt match an existing post' do
          it 'returns an error message saying post doesnt exist' do
  
          end
        end
      end
    end

    describe '#update_friend_request' do
      describe 'updates a friend request from pending to rej/accepted' do
        before :each do
          @user = User.create!(name: "Jenny", email: "jenny@tommytutone.com", google_id: "8675309", token: "fake_token_7")
          VCR.use_cassette('pending_friendships_for_jenny') do
            @users_pending_friendships = DatabaseFacade.pending_requests_to_friendships(@user.google_id)
          end
          @rejected_friendship = @users_pending_friendships.last
          @accepted_friendship = @users_pending_friendships.last
        end

        it 'returns a Friendship object' do
          VCR.use_cassette('rejecting_friendship_for_jenny', allow_playback_repeats: true ) do
            updated_friendship = DatabaseFacade.update_friend_request(@rejected_friendship.friendship_id, "rejected")
            expect(updated_friendship).to be_a(Friendship)
          end
        end

        context 'accepting request' do
          it 'returns the friendship object with updated request status' do
            VCR.use_cassette('accepting_friendship_for_jenny', allow_playback_repeats: true ) do
              updated_friendship = DatabaseFacade.update_friend_request(@accepted_friendship.friendship_id, "accepted")
              expect(updated_friendship.request_status).to eq('accepted')
            end
          end
        end

        context 'rejected request' do
          it 'returns the friendship object with updated request status' do
            VCR.use_cassette('rejected_friendship_for_jenny', allow_playback_repeats: true ) do
              updated_friendship = DatabaseFacade.update_friend_request(@rejected_friendship.friendship_id, "rejected")
              expect(updated_friendship.request_status).to eq('rejected')
            end
          end
        end
      end
    end
  end
end
