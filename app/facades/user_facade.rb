class UserFacade

  def self.find_user(google_id)
    json = UserService.find_user(google_id)
    User.new(json[:data])
  end
end
