class Friendship
  attr_reader :user_id,
              :friend_name,
              :friend_email,
              :friend_google_id,
              :friendship_id

  def initialize(friendship_data)
    @user_id = friendship_data[:id]
    @friend_name = friendship_data[:attributes][:name]
    @friend_email = friendship_data[:attributes][:email]
    @friend_google_id = friendship_data[:attributes][:google_id]
    @friendship_id = friendship_data[:friendship_id]
  end
end
