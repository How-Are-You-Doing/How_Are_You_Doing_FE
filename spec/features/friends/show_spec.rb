require 'rails_helper'

RSpec.describe 'friends show page' do
  before :each do
    @user = create(:user)
    VCR.use_cassette('emotions') do
      @emotions = DatabaseFacade.emotions
    end
    @friends_emotion = @emotions.first
    allow_any_instance_of(FriendsController).to receive(:current_user).and_return(@user)
    allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)

    friends_response = {
      "data": [{
        "id": "111",
        "type": "user",
        "attributes": {
          "name": "Legolas",
          "email": "elfstuff@hotmail.com",
          "google_id": "middleearth"
        }
      }],
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends?request_status=accepted").
      to_return(status: 200, body: friends_response)

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

    friends_response = { "data":
      [
        {
          "id": "1",
          "type": "user",
          "attributes": { "name": "Quinland Rutherford",
            "email": "sedude@hotmail.com",
            "google_id": "whares"
          }
        }
      ]
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends").
      to_return(status: 200, body: friends_response, headers: {})

  end

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
    visit '/friends'
    within("#friends_list") do
    click_link "Legolas"
    expect(current_path).to eq("/friends/middleearth/posts")
    end
  end
end
