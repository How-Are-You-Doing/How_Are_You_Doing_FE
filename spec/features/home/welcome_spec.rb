require 'rails_helper'

RSpec.describe 'welcome page' do
  describe 'as a visitor' do
    describe 'when I visit the welcome page' do
      it 'has a button to login with google oauth' do
        visit root_path
        expect(page).to have_button('Login with Google')
      end

      it 'pressing the google login button allows user to login with their google info' do
        
        
      end
    end
  end
end
