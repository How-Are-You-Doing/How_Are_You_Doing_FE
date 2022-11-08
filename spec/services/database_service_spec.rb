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
        stub_request(:get, "http://localhost:5000/api/v2/users/followers?request_status=pending&user=19023306").
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
          user_google_id = '19023306'
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

    describe '#new_post' do
      describe 'create a new post' do
        context 'when successful' do
          before :each do
            post_data = { 
                          description: 'so excited for this is a new post to be made by the front end!',
                          emotion: 'Grateful',
                          post_status: 'personal',
                          user_google_id: '8675309'
            }
  
            @user_post = UserPost.new(post_data)
            VCR.use_cassette('successful_post_creation') do
              @new_be_post = DatabaseService.new_post(@user_post)
            end
          end
          it 'returns the BE post' do
            expect(@new_be_post[:data][:attributes][:emotion]).to eq(@user_post.emotion)
            expect(@new_be_post[:data][:attributes][:post_status]).to eq(@user_post.post_status)
            expect(@new_be_post[:data][:attributes][:description]).to eq(@user_post.description)
          end
  
          it 'can be found as the last post' do
            VCR.use_cassette('post_creation_lookup') do
              expect(DatabaseService.last_post(@user_post.user_google_id)[:data][:attributes][:description]).to eq(@user_post.description)
            end
          end

        end

        context 'when unsuccessfully created' do
          # TODO
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
          it 'returns the updated BE post' do
            VCR.use_cassette('successful_post_update') do
              @updated_post = DatabaseService.update_post(@updated_data)
            end

            expect(@updated_post[:data][:id]).to eq(@new_be_post.id)
            expect(@updated_post[:data][:attributes][:emotion]).to eq(@updated_data[:emotion])
            expect(@updated_post[:data][:attributes][:post_status]).to eq(@updated_data[:post_status])
            expect(@updated_post[:data][:attributes][:description]).to eq(@updated_data[:description])
          end

          context 'not all attributes are being changed' do
            it 'returns the updated BE post with only the changed attributes different' do
              @updated_data = {
                post_status: 'shared',
                id: @new_be_post.id
              }
              VCR.use_cassette('successful_post_partial_update') do
                @updated_post = DatabaseService.update_post(@updated_data)
              end

              expect(@updated_post[:data][:id]).to eq(@new_be_post.id)
              expect(@updated_post[:data][:attributes][:emotion]).to eq(@post_data[:emotion])
              expect(@updated_post[:data][:attributes][:post_status]).to eq(@updated_data[:post_status])
              expect(@updated_post[:data][:attributes][:description]).to eq(@post_data[:description])
            end
          end
        end

        context 'the id does not match a post id' do
          it 'returns a post not found error' do
            updated_data = {
              post_status: 'public',
              id: 'A'
            }
            VCR.use_cassette('failed_post_update') do
              @updated_post = DatabaseService.update_post(updated_data)
            end
            expect(@updated_post[:error]).to eq("Not Found")
          end
        end
      end
    end

    describe '#lookup_post' do
      describe 'finds the post based on the id passed in' do
        context 'if the id matches an existing post' do
          it 'returns the post that matches the id' do
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
              @found_post = DatabaseService.lookup_post(@user, @new_be_post.id)
            end
            expect(@found_post[:data][:id]).to eq(@new_be_post.id)
          end
        end
        context 'if the id doesnt match an existing post' do
          it 'returns an error message saying post doesnt exist' do
  
          end
        end
      end
    end

    describe '#update_friend_request' do
      describe 'allows user to accept or reject a friend request' do
        before :each do
          #create request
          @user = User.create!(name: "Jenny", email: "jenny@tommytutone.com", google_id: "8675309", token: "fake_token_7")
        end

        after :each do
          #destroy request
        end

        context 'rejects request' do
          it 'returns the friendship with status as reject' do
            VCR.use_cassette('pending_friendships_for_jenny') do
              @users_pending_friendships = DatabaseFacade.pending_requests_to_friendships(@user.google_id)
            end

            rejected_friendship = @users_pending_friendships.last
            expect(rejected_friendship.request_status).to eq('pending')

            VCR.use_cassette('rejecting_friendship_for_jenny') do
              updated_friendship_data = DatabaseService.update_friend_request(rejected_friendship.friendship_id, "rejected")
              updated_friendship = Friendship.new(updated_friendship_data[:data])
              expect(updated_friendship.request_status).to eq('rejected')
            end
          end
        end

        context 'accepts request' do
          it 'returns the friendship with status as accept' do
            VCR.use_cassette('pending_friendships_for_jenny') do
              @users_pending_friendships = DatabaseFacade.pending_requests_to_friendships(@user.google_id)
            end

            accepted_friendship = @users_pending_friendships.last
            expect(accepted_friendship.request_status).to eq('pending')

            VCR.use_cassette('accepting_friendship_for_jenny') do
              updated_friendship_data = DatabaseService.update_friend_request(accepted_friendship.friendship_id, "accepted")
              updated_friendship = Friendship.new(updated_friendship_data[:data])
              expect(updated_friendship.request_status).to eq('accepted')
            end
          end
        end
      end
    end
  end
end


            # response_body = { data: {
            #   id: 1,
            #   attributes: {
            #   description: 'this is a new post made by the front end!', 
            #   emotion: 'grateful', 
            #   user_google_id: 8675309, 
            #   post_status:'private',
            #   tone: 'hungry',
            #   created_at: DateTime.now.to_s } }
            # }.to_json
            # stub_request(:post, "http://localhost:5000/api/v2/posts").with(query: post_data)
            #   .to_return(status: 200, body: response_body, headers: {})
            # stub_request(:post, "http://localhost:5000/api/v2/posts?description=this%20is%20a%20new%20post%20made%20by%20the%20front%20end!&emotion=grateful&post_status=private&user=8675309")
            #   .to_return(status: 201, body: response_body, headers: {})
            # new_be_post = DatabaseService.new_post(@user_post)

