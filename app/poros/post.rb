class Post
  attr_reader :emotion,
              :description,
              :id,
              :post_status,
              :user_google_id,
              :created_at,
              :tone

  def initialize(post_data)
    @id = post_data[:id]
    @emotion = post_data[:attributes][:emotion]
    @description = post_data[:attributes][:description]
    @post_status = post_data[:attributes][:post_status]
    @tone = post_data[:attributes][:tone]
    @created_at = post_data[:attributes][:created_at].to_datetime
  end
end
