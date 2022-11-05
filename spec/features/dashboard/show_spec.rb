require 'rails_helper'
require 'csv'

RSpec.describe 'dashboard' do
  describe 'as a user' do
    describe 'when I visit the dashboard' do
      before :each do
        @user = create(:user)
        @pending_friends = create_list(:user, 3)
        VCR.use_cassette('emotions') do
          @emotions = DatabaseFacade.emotions
        end
        @chosen_emotion = @emotions.first
        allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
        allow(DatabaseFacade).to receive(:pending_requests).with(@user.google_id).and_return(@pending_friends)
        visit dashboard_path
      end
      describe 'I see a list of my pending friend requests' do
        it 'lists the users/followers whose friend status with me are pending' do
          within '#pending_requests' do
            @pending_friends.each do |friend|
              within "#friend_#{friend.id}" do
                expect(page).to have_content(friend.name)
              end
            end
          end
        end
        it 'beside each pending request is an accept or reject button' do
          within '#pending_requests' do
            @pending_friends.each do |friend|
              within "#friend_#{friend.id}" do
                expect(page).to have_button('Accept')
                expect(page).to have_button('Reject')
              end
            end
          end
        end
        it 'pressing the accept or reject button reloads the page and the user is no longer in the list' do
          allow(DatabaseFacade).to receive(:pending_requests).with(@user.google_id).and_return(@pending_friends[1..2])
          within '#pending_requests' do
            within "#friend_#{@pending_friends.first.id}" do
              click_button 'Accept'
            end

            expect(page).to_not have_css("#friend_#{@pending_friends.first.id}")
          end
        end
        context 'there are no pending requests' do
          it 'returns a message saying there are none' do
            allow(DatabaseFacade).to receive(:pending_requests).with(@user.google_id).and_return([])
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
      end

      describe 'when I submit an emotion and description' do
        before :each do
          @last_post = build(:post)

          allow(DatabaseFacade).to receive(:new_post).and_return(201)
          allow(DatabaseFacade).to receive(:last_post).and_return(@last_post)
          allow(DatabaseFacade).to receive(:emotion_by_id).and_return(@chosen_emotion.word)

          within '#emotion_form' do
            select @chosen_emotion.word
            click_button 'submit'
          end
          within '#emotion_form' do
            fill_in :description, with: @last_post.description
            click_button 'submit'
          end
        end

        it 'returns me to the dashboard' do
          expect(current_path).to eq(dashboard_path)
        end

        it 'does not have an emotion form' do
          expect(page).to_not have_css('#emotion_form')
        end

        it 'instead shows the most recent post' do
          within '#recent_post' do
            expect(page).to have_content(@last_post.description)
            expect(page).to have_content("I am feeling #{@last_post.emotion}")
            expect(page).to have_content(@last_post.tone)
            expect(page).to have_content(@last_post.post_status)
          end
        end
      end
    end
  end
end