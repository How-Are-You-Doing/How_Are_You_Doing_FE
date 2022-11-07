require 'rails_helper'

RSpec.describe 'Post Update' do
  describe 'updating a post as the post writer (user)' do
    describe 'from the recent post on the dashboard' do
      before :each do
        VCR.use_cassette('find_user_8675309') do
          @user = UserFacade.find_user(8675309)
        end
        VCR.use_cassette('post_creation_lookup') do
          @recent_post = DatabaseFacade.last_post(8675309)
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

      end
    end
  end
end
    