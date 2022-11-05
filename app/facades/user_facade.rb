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
    
  def self.friends(user)
    UserService.friends(user)[:data].map do |data|
      UserPoro.new(data)
    end
  end

  def self.create(user)
    UserService.create(user)
  end
end
