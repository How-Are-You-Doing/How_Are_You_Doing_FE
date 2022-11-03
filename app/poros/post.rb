class Post
  attr_reader :emotion,
              :description,
              :id,
              :post_status,
              :user_id,
              :created_at,
              :tone,
              :updated_at

  def initialize(post_data)
    @id = Faker::Number.unique.number
    @emotion = post_data[:attributes][:emotion]
    @description = post_data[:attributes][:description]
    @post_status = post_data[:attributes][:post_status]
    @user_id = post_data[:attributes][:user_id]
    @tone = post_data[:attributes][:tone]
    @created_at = post_data[:attributes][:created_at]
    @updated_at = post_data[:attributes][:updated_at]
  end
end