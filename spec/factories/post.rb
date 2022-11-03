possible_post_status = %w[private public]

FactoryBot.define do
  factory :post do
    attributes {
      {
      emotion_id: Faker::Number.within(range: 1..100),
      description: Faker::Lorem.sentence,
      post_status: possible_post_status[1],
      user_id: Faker::Number.unique.within(range: 1..100),
      created_at: Faker::Time.backward(days: 5),
      tone: Faker::Lorem.word,
      updated_at: Faker::Time.backward(days: 5)
      }
    }
    initialize_with { new(attributes) }
  end
end
