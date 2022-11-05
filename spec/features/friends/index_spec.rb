require 'rails_helper'

RSpec.describe 'friends index page' do
  before :each do
    user_search_response = { "data": {
      "id": "36",
      "type": "user",
      "attributes": {
        "name": "Some Dude",
        "email": "somedude@hotmail.com",
        "google_id": "whocares"
      }
    } }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/users?email=somedude@hotmail.com").
      to_return(status: 200, body: user_search_response, headers: {})

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
                          "google_id": "hars"}
        }
      ]
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends").
      to_return(status: 200, body: friends_response, headers: {})
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

  context 'if there are no results' do
    it 'returns message' do
      user_search_response = { "data": [] }.to_json
  
      stub_request(:get, "http://localhost:5000/api/v1/users?email=somedude@hotmail.com").
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
      expect(page).to have_content("Quinland Rutherford")
      expect(page).to have_content("Spider Man")
    end
  end
end
