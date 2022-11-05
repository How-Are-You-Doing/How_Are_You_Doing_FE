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

  def self.last_post(google_id)
   post_info = DatabaseService.last_post(current_user)
   post_info[:data].map do |post_info|
    Post.new(post_info)
   end
  end

  def self.emotion_by_id(emotion_id)

  end

  def self.pending_requests(google_id)
    pending_requests = DatabaseService.pending_requests(google_id)
    return pending_requests if pending_requests.empty?
    
    pending_requests[:data].map { |user| UserPoro.new(user) }
  end
end
