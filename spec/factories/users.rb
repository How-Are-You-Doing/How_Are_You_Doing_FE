FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(domain: 'gmail') }
    token { Faker::Internet.password }
    google_id { Faker::Number.number(digits: 15) }
  end
end
