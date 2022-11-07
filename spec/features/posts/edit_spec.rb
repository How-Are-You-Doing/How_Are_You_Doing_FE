require 'rails_helper'

RSpec.describe 'Post Update' do
  describe 'updating a post' do
    context 'from the recent post on the dashboard' do
      describe 'I can edit my post' do
        it 'I see a button to edit my post' do
          within '#recent_post' do
            expect(page).to have_button('edit this post')
          end
        end
      
        it 'clicking button takes me to the post edit page' do
          within '#recent_post' do
            click_button('edit this post')
          end
          expect(current_path).to eq(edit_post)
        end
        # <%= button_to 'edit this post', dashboard_path, method: :put, params: { post_id = @recent_post.id } %>
      end
    end
  end
end
    