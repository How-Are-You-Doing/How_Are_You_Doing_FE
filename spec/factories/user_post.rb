possible_post_status = %w[personal shared]

FactoryBot.define do
  factory :user_post do
    attributes {
      {
      emotion: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      post_status: possible_post_status[0],
      user_google_id: Faker::Number.unique.within(range: 1..100)
      }
    }
    initialize_with { new(attributes) }
  end
end