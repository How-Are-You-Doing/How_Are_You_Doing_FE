# UserPost is a post that has originated from the user and is not yet in the backend database

class UserPost
  attr_reader :emotion,
              :description,
              :post_status,
              :user_google_id


  def initialize(post_data)
    @emotion = post_data[:emotion]
    @description = post_data[:description]
    @post_status = post_data[:post_status]
    @user_google_id = post_data[:user_google_id]
  end
end