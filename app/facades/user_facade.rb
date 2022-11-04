class UserFacade
  def self.create_user(user_params)
    UserService.create_user(user_params)
  end

  def self.find_user(google_id)
    json = UserService.find_user(google_id)
    UserPoro.new(json[:data])
  end

  def self.search(email)
    UserPoro.new(UserService.search(email)[:data])
  end

  def self.friends_of(user)
    UserService.friends_of(user)[:data].map do |data|
      UserPoro.new(data)
    end
  end
end
