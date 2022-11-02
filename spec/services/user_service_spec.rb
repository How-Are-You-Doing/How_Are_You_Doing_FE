require 'rails_helper'

RSpec.describe UserService do
  describe '.find_user' do
    it 'can find a user based on google id' do
      response_body = { "data": {
        "id": "36",
        "type": "user",
        "attributes": {
          "name": "Jacob Methusula",
          "email": "jsnakes@gmail.com",
          "google_id": "fhsajbd912671284bf001028472jf"
        }
      } }.to_json

      stub_request(:get, "http://localhost:5000/api/v1/users?search=fhsajbd912671284bf001028472jf").
        to_return(status: 200, body: response_body, headers: {})

      result = UserService.find_user("fhsajbd912671284bf001028472jf")

      expect(result[:data][:attributes][:name]).to eq("Jacob Methusula")
      expect(result[:data][:attributes][:email]).to eq("jsnakes@gmail.com")
      expect(result[:data][:attributes][:google_id]).to eq("fhsajbd912671284bf001028472jf")
    end
  end
end
