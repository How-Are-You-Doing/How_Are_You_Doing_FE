require 'rails_helper'

RSpec.describe 'history index page', type: :feature do
  describe 'As a visitor' do
    describe 'When I visit the show page' do
        before :each do
          @user_1 = User.find_by(google_id: 52785579)    
        
          visit '/history'
        end

      it "I see a section on how I've been doing. Under that section, I see a list of all my public and private posts. I see the date, and a list of public and private as well as my description with more details." do

        expect(page).to have_content("How You've Been Doing Lately")
        within('#history') do  
save_and_open_page
          user_1_posts_shared.each do |post| 
            expect(page).to have_content("#{post.emotion}")
            expect(page).to have_content("#{post.description}")
            expect(page).to have_content("#{post.post_status}")
            expect(page).to have_content("#{post.tone}")
          end
        end
      end
    end
  end
end