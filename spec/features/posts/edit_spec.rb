require 'rails_helper'

# save_and_open_page

RSpec.describe 'Post Update' do
  describe 'updating a post as the post writer (user)' do
    describe 'from the recent post on the dashboard' do
      before :each do
        VCR.use_cassette('find_user_8675309') do
          @user = UserFacade.find_user(8675309)
        end
        VCR.use_cassette('find_post_by_id') do
          @recent_post = DatabaseFacade.lookup_post(@user, 30)
        end

        @pending_friends = create_list(:user, 3)
        allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
        allow_any_instance_of(PostsController).to receive(:current_user).and_return(@user)
        allow(DatabaseFacade).to receive(:pending_requests).with(@user.google_id).and_return(@pending_friends)
        allow_any_instance_of(DashboardsController).to receive(:recently_posted?).and_return(true)
        allow(DatabaseFacade).to receive(:last_post).with('8675309').and_return(@recent_post)

        visit dashboard_path
      end
      describe 'I can edit my post' do
        it 'I see a button to edit my post' do
          within "#post_#{@recent_post.id}" do
            expect(page).to have_button('edit this post')
          end
        end
      
        it 'clicking button takes me to the post edit page' do
          VCR.use_cassette('find_post_by_id') do
            within "#post_#{@recent_post.id}" do
              click_button('edit this post')
            end
          end
          expect(current_path).to eq(edit_post_path)
        end
      end

      describe 'edit page' do
        before :each do
          VCR.use_cassette('emotions') do
            VCR.use_cassette('find_post_by_id') do
              within "#post_#{@recent_post.id}" do
                click_button('edit this post')
              end
            end
          end 
        end

        describe 'has a drop down for feelings with the feeling selected from the original post' do
          it 'has a drop down menu with a list of all emotions' do
            VCR.use_cassette('emotions') do
              @emotions = DatabaseFacade.emotions
            end
            within '#emotion_form' do
              @emotions.each do |emotion|
                page.has_select? emotion.word
              end
            end
          end

          it 'has selected the feeling from the original post' do
            within '#emotion_form' do
              expect(find_field(:emotion).value).to eq(@recent_post.emotion)
            end
          end
        end

        it 'has a text box with the text from the previous post already in it' do
          within '#emotion_form' do
            expect(find_field(:description).value).to eq(@recent_post.description)
          end
        end

        it 'has a selection for personal or shared with the original posts selection selected' do
          within '#emotion_form' do
            expect(find_field(:post_status, with: @recent_post.post_status).checked?).to eq(true)
          end
        end

        it 'has a submit button' do
          within '#emotion_form' do
            expect(page).to have_button('submit')
          end
        end
        context 'all necessary info inputted on form' do
          it 'pressing submit button take you back to your original page' do
            choose 'No'
            VCR.use_cassette('edit_feature_change_post_status') do
              click_button 'submit'
            end
            expect(current_path).to eq(dashboard_path)
          end

          it 'and can see the updated post on that page' do
            choose 'No'
            VCR.use_cassette('edit_feature_change_post_status') do
              click_button 'submit'
            end
            expect(current_path).to eq(dashboard_path)
            within "#post_#{@recent_post.id}" do
              expect("This post is currently personal")
            end
          end
        end
      end
    end
  end
end
    