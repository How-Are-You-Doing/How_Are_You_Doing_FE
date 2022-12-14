possible_post_status = %w[private public]

FactoryBot.define do
  factory :post do
    id { Faker::Number.unique.within(range: 1..100)}
    attributes {
      {
      emotion: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      post_status: possible_post_status[0],
      created_at: Faker::Time.backward(days: 5),
      tone: Faker::Lorem.word,
      }
    }
    initialize_with { new(attributes) }
  end
end
