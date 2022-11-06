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
    require 'pry'; binding.pry
    @id = post_data[:id]
    @emotion = post_data[:attributes][:emotion]
    @description = post_data[:attributes][:description]
    @post_status = post_data[:attributes][:post_status]
    @tone = post_data[:attributes][:tone]
    @created_at = post_data[:attributes][:created_at]
  end
end
