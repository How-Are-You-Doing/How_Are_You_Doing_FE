module EmotionHelper
  def words_only(emotions_grid)
    emotions_grid.map(&:word)
  end

  def lookup_emotion(emotion_word)
    DatabaseFacade.emotions.find { |emotion| emotion.word == emotion_word }
  end

  def description_empty?
    params[:description] == ""
  end

  def back_to_description
    flash[:error] = "Post Description must have content"
    redirect_back(fallback_location: dashboard_path) 
  end
end