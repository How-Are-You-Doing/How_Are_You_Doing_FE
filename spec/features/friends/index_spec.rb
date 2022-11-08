require 'rails_helper'

RSpec.describe 'friends index page' do
  before :each do
    @user = create(:user, google_id: '19023306')
    allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
    allow_any_instance_of(FriendsController).to receive(:current_user).and_return(@user)
  end

  describe 'I see the nav bar' do
    before :each do
      VCR.use_cassette('go_to_friends_path') do
        visit friends_path
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

  it 'has a friends index page with a search field to find new users by email' do
    VCR.use_cassette('go_to_friends_path') do
      visit '/friends'

      VCR.use_cassette('find_friend_jenny') do
        within("#find_friend_form") do
          fill_in 'Email', with: "jenny@tommytutone.com"
          click_button 'Find Friend'
        end

        within("#search_results") do
          expect(page).to have_content("Jenny")
        end
      end
    end
  end

  it 'has a button to follow a new friend' do
    VCR.use_cassette('go_to_friends_path') do
      visit 'friends'
      VCR.use_cassette('find_friend_jenny') do
        fill_in 'Email', with: "jenny@tommytutone.com"
        click_button 'Find Friend'

        expect(page).to have_content("Jenny")
        VCR.use_cassette('request_friend_jenny') do
          click_button 'Send Friend Request'
          expect(current_path).to eq('/friends')
        end
      end
    end
  end

  it 'returns a message when a friend request is successfully sent' do
     VCR.use_cassette('go_to_friends_path') do
      visit 'friends'
      VCR.use_cassette('find_friend_jenny') do
        fill_in 'Email', with: "jenny@tommytutone.com"
        click_button 'Find Friend'
        VCR.use_cassette('request_friend_jenny') do
          click_button 'Send Friend Request'
          expect(page).to have_content("Friend Request Sent Successfully")

          within("#sent_friend_requests") do
            expect(page).to have_content("jenny@tommytutone.com")
          end
        end
      end
    end
  end

  context 'if there are no results' do
    it 'returns message' do
      VCR.use_cassette('go_to_friends_path_2') do
        visit '/friends'

        VCR.use_cassette('find_nonexistent_friend') do
          within("#find_friend_form") do
            fill_in 'Email', with: "somedude@hotmail.com"
            click_button 'Find Friend'
          end

          within("#search_results") do
            expect(page).to have_content('No search results')
          end
        end
      end
    end
  end

  it 'has a list of friends the user follows and has been accepted by' do
    VCR.use_cassette('go_to_friends_path') do
      visit '/friends'
      within("#friends_list") do
        expect(page).to have_content("Bubbles")
      end
    end
  end


  it 'has a button to return to user dashboard page' do
    VCR.use_cassette('go_to_friends_path') do
      visit '/friends'
      click_button 'Dashboard'
      VCR.use_cassette('dashboard_return') do
        VCR.use_cassette('last_post_of_user') do
          expect(current_path).to eq(dashboard_path)
        end
      end
    end
  end
end
