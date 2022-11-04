require 'rails_helper'

RSpec.describe DatabaseFacade do
  describe 'class methods' do
    describe '#pending_requests' do
      context 'when the user has pending requests' do
        it 'returns only the users that are followers of the user_id with status as pending' do
  
        end
  
        it 'returns an array of User objects' do
  
        end
      end

      context 'when the user has no pending requests' do
        it 'returns an empty array' do
          
        end
      end
    end
  end
end