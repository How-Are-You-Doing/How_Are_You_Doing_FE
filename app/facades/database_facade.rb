class DatabaseFacade
  def self.emotions
    Rails.cache.fetch("my_cache_key/emotions", expires_in: 24.hours) do
      emotions = DatabaseService.emotions[:data]
      emotions.map { |emotion| Emotion.new(emotion) }
    end
  end

  def self.emotion(emotion_word)

  end

  def self.new_post(post_params)

  end

  def self.last_post(user_id)
    
  end

  def self.emotion_by_id(emotion_id)

  end

  #these are incoming friend requests in the pending state
  def self.pending_requests(google_id)
    pending_requests = DatabaseService.users_pending_requests(google_id)
    return pending_requests if pending_requests.empty?
    pending_requests[:data].map { |user| UserPoro.new(user) }
  end

  #these are outgoing friend requests in the pending state
  def self.sent_friend_requests(google_id)
    requests = DatabaseService.sent_requests(google_id)
    return requests if requests.empty?
    requests[:data].map { |user| UserPoro.new(user) }
  end
end
