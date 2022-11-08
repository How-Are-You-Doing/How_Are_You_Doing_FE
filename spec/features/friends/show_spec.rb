require 'rails_helper'

RSpec.describe 'friends show page' do
  before :each do
    @user = create(:user, google_id: "19023306")
    VCR.use_cassette('emotions') do
      @emotions = DatabaseFacade.emotions
    end
    @friends_emotion = @emotions.first
    allow_any_instance_of(FriendsController).to receive(:current_user).and_return(@user)
    allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
  end


  # it 'has a link to each friends show p91age from the friends list index' do

  # describe 'I see the nav bar' do
  #   before :each do
  #     visit "/friends/middleearth/posts"
  #   end
  #   it 'has Dashboard button' do
  #     within '#account' do
  #       expect(page).to have_button('Dashboard')
  #     end
  #   end

  #   it 'has Logout button' do
  #     within '#account' do
  #       expect(page).to have_button('Logout')
  #     end
  #   end
  # end

  it 'has a link to each friends show page from the friends list index' do
    VCR.use_cassette('go_to_friends_path') do
      visit '/friends'
      VCR.use_cassette('veiw_bubbles_posts') do
        within("#friends_list") do
          click_link "Bubbles"
          expect(current_path).to eq("/friends/7357151/posts")
        end
        expect(page).to have_content("Bubbles's Recent Posts")
      end
    end
  end

  it 'displays a list of a friends posts' do
    VCR.use_cassette('veiw_bubbles_posts') do
      visit "/friends/7357151/posts"
      within("#posts") do
        expect(page).to have_content("Tuesday, November 01, 2022")
        expect(page).to have_content("Emotion: Affectionate")
        expect(page).to have_content("Description: This is the text for user 2 post 1")
        expect(page).to have_content("Tone: relaxed")
      end
    end
  end
end
