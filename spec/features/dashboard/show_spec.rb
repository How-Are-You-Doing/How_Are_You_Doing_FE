require 'rails_helper'
require 'csv'

RSpec.describe 'dashboard' do
  describe 'as a user' do
    describe 'when I visit the dashboard' do
      before :each do
        @user = create(:user)
        emotions_list = CSV.parse(File.read('spec/emotions_list/Emotions.csv'), headers:true)
        @emotions = emotions_list.map {|emotion| Emotion.new(emotion)} 
        allow(DatabaseFacade).to receive(:emotions).and_return(@emotions)
        allow_any_instance_of(DashboardsController).to receive(:current_user).and_return(@user)
        visit dashboard_path
      end
      it 'has a welcome message with users name' do
        expect(page).to have_content("Welcome, #{@user.name}")
      end

      it 'has a drop down menu with a list of all emotions' do
        
      end

      it 'when I hover over an emotion, the words definition appears' do

      end

      it 'choosing a feeling word and pressing submit refreshes dashboard without dropdown' do

      end
    end
  end
end