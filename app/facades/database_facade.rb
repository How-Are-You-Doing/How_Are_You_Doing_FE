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

  def self.pending_requests(google_id)
    pending_requests = DatabaseService.pending_requests(google_id)
    return pending_requests if pending_requests.empty?
    
    pending_requests[:data].map { |user| UserPoro.new(user) }
  end

  def self.new_post(post)
    post_data = DatabaseService.new_post(post)
    Post.new(post_data[:data])
  end

  def self.update_post(updated_post_params)
    updated_post = DatabaseService.update_post(updated_post_params)
    Post.new(updated_post[:data])
  end

  def self.lookup_post(post_id)
    found_post = DatabaseService.lookup_post(post_id)
    # return post_info[:data] if post_info[:data].empty?

    Post.new(found_post[:data])
  end
end
