class UserService

  def self.find_user(google_id)
    response = DatabaseService.conn.get("/api/v1/users?search=#{google_id}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.search(email)
    response = DatabaseService.conn.get("/api/v1/users?by_email=#{email}")
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.friends
    response = DatabaseService.conn.get("api/v1/friends")
    JSON.parse(response.body, symbolize_names: true)
  end
end
