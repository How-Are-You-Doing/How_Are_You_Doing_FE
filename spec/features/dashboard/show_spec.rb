require 'rails_helper'
require 'csv'

RSpec.describe 'dashboard' do
  describe 'as a user' do
    describe 'when I visit the dashboard' do
      before :each do
        @user = User.create!(name: "Jenny", email: "jenny@tommytutone.com", google_id: "8675309", token: "fake_token_7")
        VCR.use_cassette('pending_friendships_for_jenny') do
          @pending_friends = DatabaseFacade.pending_requests_to_friendships(@user.google_id)
        end
        VCR.use_cassette('emotions') do
          @emotions = DatabaseFacade.emotions
        end
        @chosen_emotion = @emotions.first
        allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
        allow(DatabaseFacade).to receive(:pending_requests_to_friendships).with(@user.google_id).and_return(@pending_friends)
        allow_any_instance_of(DashboardsController).to receive(:recently_posted?).and_return(false)
        visit dashboard_path
      end

      describe 'I see the nav bar' do
        it 'has friends button' do
          within '#account' do
            expect(page).to have_button('Friends')
          end
        end

        it 'has Logout button' do
          within '#account' do
            expect(page).to have_button('Logout')
          end
        end

        it 'has History button' do
          within '#account' do
            expect(page).to have_button('History')
          end
        end
      end

      describe 'I see a list of my pending friend requests' do
        it 'lists the users/followers whose friend status with me are pending' do

          visit dashboard_path
          within '#pending_requests' do
            @pending_friends.each do |friend|
              within "#friend_#{friend.friendship_id}" do
                expect(page).to have_content(friend.friend_name)
              end
            end
          end
        end
        it 'beside each pending request is an accept or reject button' do
          within '#pending_requests' do
            @pending_friends.each do |friend|
              within "#friend_#{friend.friendship_id}" do
                expect(page).to have_button('Accept')
                expect(page).to have_button('Reject')
              end
            end
          end
        end
        it 'pressing the accept or reject button reloads the page and the user is no longer in the list' do
          allow(DatabaseFacade).to receive(:pending_requests_to_friendships).with(@user.google_id).and_return([])
          within '#pending_requests' do
            within "#friend_#{@pending_friends.first.friendship_id}" do
              click_button 'Accept'
            end
          end
          visit dashboard_path
          within '#pending_requests' do
            expect(page).to_not have_css("#friend_#{@pending_friends.first.friendship_id}")
          end
        end
        context 'there are no pending requests' do
          it 'returns a message saying there are none' do
            allow(DatabaseFacade).to receive(:pending_requests_to_friendships).with(@user.google_id).and_return([])
            visit dashboard_path
            within '#pending_requests' do
              expect(page).to have_content('No Pending Requests')
            end
          end
        end
      end

      context 'I have not posted recently' do
        it 'has a welcome message with users name' do
          expect(page).to have_content("Welcome, #{@user.name}")
        end

        it 'has a drop down menu with a list of all emotions' do
          within '#emotion_form' do
            @emotions.each do |emotion|
              page.has_select? emotion.word
            end
          end
        end
      end

      describe 'when I submit an emotion' do
        before :each do
          within '#emotion_form' do
            select @chosen_emotion.word
            click_button 'submit'
          end
        end
        it 'I am returned to the dashboard page' do
          expect(current_path).to eq(dashboard_path)
        end

        it 'I see the definition of the emotion' do
          within '#emotion_def' do
            expect(page).to have_content(@chosen_emotion.definition)
          end
        end

        it 'I see a text box appear' do
          within '#emotion_form' do
            expect(page).to have_field(:description, type: 'textarea')
          end
        end

        it 'I see a post status radio button with yes and no' do
          within '#emotion_form' do
            expect(page).to have_field('Yes')
            expect(page).to have_field('No')
          end
        end

        it 'post status public question is no by default' do
          within '#emotion_form' do
            expect(page).to have_checked_field('No')
          end
        end

        it 'I see a link to change emotion choice' do
          expect(page).to have_link('Change emotion choice')
        end

        it 'clicking link to change emotion choice takes me back to dashboard page with dropdown' do
          click_link 'Change emotion choice'
          expect(current_path).to eq(dashboard_path)
          within '#emotion_form' do
            @emotions.each do |emotion|
              page.has_select? emotion.word
            end
          end
        end

        context 'submit an emotion with no text in description' do
          it 'returns me back to description page with flash message' do
            allow_any_instance_of(DashboardsController).to receive(:flash).and_return(error: "Post Description must have content")
            within '#emotion_form' do
              fill_in :description, with: ""
              click_button 'submit'
            end
            expect(current_path).to eq(dashboard_path)
            expect(page).to have_content("Post Description must have content")
          end
        end
      end

      describe 'when I submit an emotion and description' do
        before :each do
          @last_post = build(:post)

          allow(DatabaseFacade).to receive(:new_post).and_return(@last_post)
          allow(DatabaseFacade).to receive(:last_post).and_return(@last_post)

          within '#emotion_form' do
            select @chosen_emotion.word
            click_button 'submit'
          end
          allow_any_instance_of(DashboardsController).to receive(:recently_posted?).and_return(true)
          allow_any_instance_of(DashboardsController).to receive(:flash).and_return(success: "Post Created!")
          within '#emotion_form' do
            fill_in :description, with: @last_post.description
            click_button 'submit'
          end
        end

        it 'returns me to the dashboard' do
          expect(current_path).to eq(dashboard_path)
        end

        context 'successfully created post' do
          it 'flash message saying post has been created' do
            expect(page).to have_content("Post Created!")
          end
        end

        it 'does not have an emotion form' do
          expect(page).to_not have_css('#emotion_form')
        end

        it 'instead shows the most recent post' do
          within "#post_#{@last_post.id}" do
            expect(page).to have_content(@last_post.description)
            expect(page).to have_content("I am feeling #{@last_post.emotion}")
            expect(page).to have_content(@last_post.tone)
            expect(page).to have_content(@last_post.post_status)
          end
        end
      end

      describe 'I can delete my post' do
        it 'can allow the user to delete their post off user dashboard' do
          VCR.use_cassette('user_delete_post') do
            post_data = {
              description: "trying to delete post",
              emotion: 'Embarrassed',
              post_status: 'personal',
              user_google_id: '8675309'
            }

            @user_post = DatabaseFacade.new_post(UserPost.new(post_data))

            allow_any_instance_of(DashboardsController).to receive(:recently_posted?).and_return(true)
            allow(DatabaseFacade).to receive(:last_post).with('8675309').and_return(@user_post)

            visit dashboard_path
            allow_any_instance_of(DashboardsController).to receive(:recently_posted?).and_return(false)

            within("#post_#{@user_post.id}") do
              click_button 'Delete'
              expect(current_path).to eq dashboard_path
            end
            expect(page).to_not have_content(@user_post.description)
            expect(page).to_not have_content(@user_post.tone)
          end
        end
      end
    end
  end
end
