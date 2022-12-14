class UserFacade
  def self.find_user(google_id)
    json = UserService.find_user(google_id)
    UserPoro.new(json[:data])
  end

  def self.search(email)
    user_data = UserService.search(email)[:data]
    return user_data if user_data.empty?
    UserPoro.new(user_data)
  end

  def self.relationships_filter(user, request_status)
    UserService.user_relationships_filter(user, request_status)[:data].map do |data|
      UserPoro.new(data)
    end
  end
    
  def self.friends(user)
    UserService.friends(user)[:data].map do |data|
      UserPoro.new(data)
    end
  end

  def self.friend_posts(google_id)
    UserService.friend_posts(google_id)[:data].map do |data|
      Post.new(data)
    end
  end


  def self.create(user)
    UserService.create(user)
  end

  def self.send_friend_request(current_user, email)
    UserService.send_friend_request(current_user, email)
  end
end
