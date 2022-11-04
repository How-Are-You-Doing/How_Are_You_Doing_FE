class UserFacade
  def self.find_user(google_id)
    json = UserService.find_user(google_id)
    UserPoro.new(json[:data])
  end

  def self.search(email)
    UserService.search(email)[:data].map do |data|
      UserPoro.new(data)
    end
  end

  def self.friends
    UserService.friends[:data].map do |data|
      UserPoro.new(data)
    end
  end
end
