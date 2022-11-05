# UserPost is a post that has originated from the user and is not yet in the backend database

class UserPost
  attr_reader :emotion,
              :description,
              :id,
              :post_status,
              :user_id


  def initialize(post_data)
    @id = Faker::Number.unique.number
    @emotion = post_data[:attributes][:emotion]
    @description = post_data[:attributes][:description]
    @post_status = post_data[:attributes][:post_status]
    @user_id = post_data[:attributes][:user_id]
  end
end