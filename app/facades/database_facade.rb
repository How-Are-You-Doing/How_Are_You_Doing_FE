class DatabaseFacade
  def self.emotions
    Rails.cache.fetch("my_cache_key/emotions", expires_in: 24.hours) do
      emotions = DatabaseService.emotions[:data]
      emotions.map { |emotion| Emotion.new(emotion) }
    end
  end

  def self.last_post(google_id)
    post_info = DatabaseService.last_post(google_id)
    return post_info[:data] if post_info[:data].empty?

    Post.new(post_info[:data])
  end

  def self.emotion_by_id(emotion_id)

  end

  #these are incoming friend requests in the pending state
  def self.pending_requests(google_id)
    pending_requests = DatabaseService.users_pending_requests(google_id)
    # return pending_requests if pending_requests.empty?
    pending_requests[:data].map { |user| UserPoro.new(user) }
  end

  #these are outgoing friend requests in the pending state
  def self.sent_friend_requests(google_id)
    requests = DatabaseService.sent_requests(google_id)
    requests[:data].map { |user| UserPoro.new(user) }
    end
    
  def self.new_post(post)
    post_data = DatabaseService.new_post(post)
    Post.new(post_data[:data])
  end

  def self.update_post(updated_post_params)
    updated_post = DatabaseService.update_post(updated_post_params)
    Post.new(updated_post[:data])
  end

  def self.delete_post(post_id)
    delete_post = DatabaseService.delete_post(post_id)
  end

  def self.lookup_post(user_id, post_id)
    found_post = DatabaseService.lookup_post(user_id, post_id)
    # return post_info[:data] if post_info[:data].empty?

    Post.new(found_post[:data])
  end


  def self.user_post_history(google_id)
    user_history = DatabaseService.user_post_history(google_id)
    user_history[:data].map do |user_post|
      Post.new(user_post)
    end
  end


end
