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
          "attributes": { "name": "Legolas",
            "email": "sedude@hotmail.com",
            "google_id": "middleearth"
          }
        }
      ]
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends").
      to_return(status: 200, body: friends_response, headers: {})

    friend_posts_response = { "data": [
      {
        "id": "1",
        "type": "post",
        "attributes":
          {
            "emotion": "happy",
            "post_status": "public",
            "description": "feeling happy",
            "tone": "joyful",
            "created_at": "Tue, 01 Nov 2022 11:51:06 -0700"

          }
      },
      {
        "id": "2",
        "type": "post",
        "attributes":
          { "emotion": "sad",
            "post_status": "private",
            "description": "stuck on code",
            "tone": "upset",
            "created_at": "Tue, 08 Nov 2022 11:51:06 -0700"

          }
      }
    ]
    }.to_json

    stub_request(:get, "http://localhost:5000/api/v1/friends/middleearth/posts").
      to_return(status: 200, body: friend_posts_response)

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

    visit '/friends'
    within("#friends_list") do
      click_link "Legolas"
      expect(current_path).to eq("/friends/middleearth/posts")
    end
    expect(page).to have_content("Legolas's Recent Posts")
  end

  it 'displays a list of a friends posts' do
    visit "/friends/middleearth/posts"
    within("#posts") do
      expect(page).to have_content("Tuesday, November 01, 2022")
      expect(page).to have_content("Emotion: happy")
      expect(page).to have_content("Description: feeling happy")
      expect(page).to have_content("Tone: joyful")
    end
  end

  it 'displays the dashboard and history buttons' do
    visit "/friends/middleearth/posts"
      expect(page).to have_button("Dashboard")
      expect(page).to have_button("History")
  end
end
