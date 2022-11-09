require 'rails_helper'

RSpec.describe 'history index page', type: :feature do
  describe 'As a visitor' do
    describe 'When I visit the show page' do
      before :each do
        # @user = User.create!(name: "Randy Bobandy", email: "assistantsupervisor@sunnyvale.ca", google_id: 52785579, token: 'asdfd15')

        # allow_any_instance_of(PostsController).to receive(:current_user).and_return(@user)

      end

      describe 'I see the nav bar' do
        before :each do
          @user = create(:user)
          allow_any_instance_of(PostsController).to receive(:current_user).and_return(@user)
          allow(DatabaseFacade).to receive(:user_post_history).and_return([])
          visit history_path
        end

        it 'has friends button' do
          within '#account' do
            expect(page).to have_button('Friends')
          end
        end

        it 'has Dashboard button' do
          within '#account' do
            expect(page).to have_button('Dashboard')
          end
        end

        it 'has Logout button' do
          within '#account' do
            expect(page).to have_button('Logout')
          end
        end
      end

      it "I see a section on how I've been doing. Under that section, I see a list of all my public and private posts. I see the date, and a list of public and private as well as my description with more details." do
        @user = User.create!(name: "Randy Bobandy", email: "assistantsupervisor@sunnyvale.ca", google_id: 52785579, token: 'asdfd15')

        allow_any_instance_of(PostsController).to receive(:current_user).and_return(@user)
        VCR.use_cassette('user_info') do
          user_posts = DatabaseFacade.user_post_history(@user.google_id)

          visit '/history'

          expect(page).to have_content("How You've Been Doing Lately")
          within('#history') do
            user_posts.each do |post|
              expect(page).to have_content("#{post.emotion}")
              expect(page).to have_content("#{post.description}")
              expect(page).to have_content("#{post.post_status}")
              expect(page).to have_content("#{post.tone}")
            end
          end
        end
      end

      it "If i am a user with no posts I see 'You have no posts yet' on my history page" do

        @user_2_lonely = User.create!(name: "Lonely", email: "noposts@lonely.alone", google_id: 8675310, token: 'fake_token')

        allow_any_instance_of(PostsController).to receive(:current_user).and_return(@user_2_lonely)
        VCR.use_cassette('lonely_user_info') do

          user_posts = DatabaseFacade.user_post_history(@user_2_lonely.google_id)

          visit '/history'

          expect(page).to have_content("How You've Been Doing Lately")
          expect(page).to have_content("You don't have any posts.")
        end
      end

      it "has a button to delete a users posts from the post history page" do
        VCR.use_cassette('delete_posts') do
          @user = User.create!(name: "Bubbles", email: "catlover69@hotmail.com", google_id: "7357151", token: "s23463")
          allow_any_instance_of(PostsController).to receive(:current_user).and_return(@user)

          post_data = {
            description: "'don't feel this way anymore so going to delete!'",
            emotion: 'Embarrassed',
            post_status: 'personal',
            user_google_id: '7357151'
          }

          @user_post = DatabaseFacade.new_post(UserPost.new(post_data))
          visit '/history'

          VCR.use_cassette('redirect_back') do
            within("#post_#{@user_post.id}") do
              click_button 'Delete'
              expect(current_path).to eq(history_path)
            end
              expect(page).to_not have_content(@user_post.description)
              expect(page).to_not have_content(@user_post.emotion)
              expect(page).to_not have_content(@user_post.created_at)
              end
            end
          end
        end
      end
    end

