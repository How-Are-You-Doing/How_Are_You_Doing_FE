require 'rails_helper'

RSpec.describe 'friends index page' do
  before :each do
    @user = create(:user, google_id: '91239464')
    allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
    allow_any_instance_of(FriendsController).to receive(:current_user).and_return(@user)
    user_search_response = { "data": {
      "id": "36",
      "type": "user",
      "attributes": {
        "name": "Some Dude",
        "email": "somedude@hotmail.com",
        "google_id": "whocares"
      }
    } }.to_json

    stub_request(:get, "http://localhost:5000/api/v2/users?email=somedude@hotmail.com").
      to_return(status: 200, body: user_search_response, headers: {})

    user_2 = { "data": {
      "id": "48",
      "type": "user",
      "attributes": {
        "name": "Frodo",
        "email": "frodo@hotmail.com",
        "google_id": "googleid"
      }
    },
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v2/users?email=frodo@hotmail.com").
      to_return(status: 200, body: user_2, headers: {})

    user_3 = { "data": {
      "id": "48",
      "type": "user",
      "attributes": {
        "name": "Fofandalf",
        "email": "wizardstuff3@hotmail.com",
        "google_id": "midtierearth"
      }
    },
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v2/users?email=wizardstuff3@hotmail.com").
      to_return(status: 200, body: user_3, headers: {})

    friends_response = { "data":
      [
        {
          "id": "1",
          "type": "user",
          "attributes": { "name": "Quinland Rutherford",
            "email": "sedude@hotmail.com",
            "google_id": "whares"
          }
        },
        {
          "id": "2",
          "type": "user",
          "attributes": { "name": "Spider Man",
            "email": "sedu@hotmail.com",
            "google_id": "hars" }
        }
      ]
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends").
      to_return(status: 200, body: friends_response, headers: {})

    accepted_friends_response = {
      "data": [{
        "id": "111",
        "type": "user",
        "attributes": {
          "name": "Gandalf",
          "email": "wizardstuff@hotmail.com",
          "google_id": "middleearth"
        }
      }],
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends?request_status=accepted").
      to_return(status: 200, body: accepted_friends_response)

    rejected_friends_response = {
      "data": [{
        "id": "112",
        "type": "user",
        "attributes": {
          "name": "Shmandalf",
          "email": "wizardstuff2@hotmail.com",
          "google_id": "centerearth"
        }
      }],
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends?request_status=rejected").
      to_return(status: 200, body: rejected_friends_response)

    pending_friends_response = {
      "data": [{
        "id": "113",
        "type": "user",
        "attributes": {
          "name": "Fofandalf",
          "email": "wizardstuff3@hotmail.com",
          "google_id": "midtierearth"
        }
      }],
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends?request_status=pending").
      to_return(status: 200, body: pending_friends_response)


    sent_friend_request_response = { "data":
      { "attributes":
        { "email": "wizardstuff3@hotmail.com" }
      }
    }.to_json

    stub_request(:post, "http://localhost:5000/api/v1/friends?email=wizardstuff3@hotmail.com").
      to_return(status: 201, body: sent_friend_request_response)

    incoming_friend_requests_response = { data: [

    ] }
    stub_request(:get, "http://localhost:5000/api/v2/users/followers?request_status=pending").
      to_return(status: 200, body: incoming_friend_requests_response.to_json, headers: {})
  end

  describe 'I see the nav bar' do
    before :each do
      visit friends_path
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
    visit '/friends'

    within("#find_friend_form") do
      fill_in 'Email', with: "somedude@hotmail.com"
      click_button 'Find Friend'
    end

    within("#search_results") do
      expect(page).to have_content("Some Dude")
    end
  end

  it 'has a button to follow a new friend' do
    visit 'friends'
    fill_in 'Email', with: "wizardstuff3@hotmail.com"
    click_button 'Find Friend'

    expect(page).to have_content("Fofandalf")
    click_button 'Send Friend Request'
    expect(current_path).to eq('/friends')
  end

  it 'returns a message when a friend request is successfully sent' do
    visit 'friends'
    fill_in 'Email', with: "wizardstuff3@hotmail.com"
    click_button 'Find Friend'
    click_button 'Send Friend Request'
    expect(page).to have_content("Friend Request Sent Successfully")

    within("#sent_friend_requests") do
      expect(page).to have_content("wizardstuff3@hotmail.com")
    end
  end

  context 'if there are no results' do
    it 'returns message' do
      user_search_response = { "data": [] }.to_json

      stub_request(:get, "http://localhost:5000/api/v2/users?email=somedude@hotmail.com").
        to_return(status: 200, body: user_search_response, headers: {})

      visit '/friends'

      within("#find_friend_form") do
        fill_in 'Email', with: "somedude@hotmail.com"
        click_button 'Find Friend'
      end

      within("#search_results") do
        expect(page).to have_content('No search results')
      end
    end
  end

  it 'has a list of friends the user follows and has been accepted by' do
    visit '/friends'
    within("#friends_list") do
      expect(page).to have_content("Gandalf")
    end
  end

  it 'has a button to return to user dashboard page' do
    VCR.use_cassette('dashboard_return') do
      VCR.use_cassette('last_post_of_user') do
      visit '/friends'
      click_button 'Dashboard'
      expect(current_path).to eq(dashboard_path)
      end
    end
  end
end
