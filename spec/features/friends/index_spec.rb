require 'rails_helper'

RSpec.describe 'friends index page' do
  before :each do
    response_body = { "data": [{
      "id": "36",
      "type": "user",
      "attributes": {
        "name": "Some Dude",
        "email": "somedude@hotmail.com",
        "google_id": "whocares"
      }
    }] }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/users?by_email=somedude@hotmail.com").
      to_return(status: 200, body: response_body, headers: {})
  end

  it 'has a friends index page with a list of users friends' do
    visit '/friends'

    within("#find_friend_form") do
      fill_in 'Email', with: "somedude@hotmail.com"
      click_button 'Find Friend'
    end

    within("#search_results") do
      expect(page).to have_content("Some Dude")
    end
  end
end
