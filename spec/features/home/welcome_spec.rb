require 'rails_helper'

RSpec.describe 'welcome page' do
  describe 'as a visitor' do
    describe 'when I visit the welcome page' do
      it 'has a button to login with google oauth' do
        visit root_path
        expect(page).to have_button('Login with Google')
      end
    end
  end
end
