class UserService

  def self.find_user(google_id)
    response = DatabaseService.conn.get("/api/v1/users?search=#{google_id}")
    JSON.parse(response.body, symbolize_names: true)
  end
end
