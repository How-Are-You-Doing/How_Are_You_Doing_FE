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
              @found_post = DatabaseService.lookup_post(@new_be_post.id)
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