module EmotionHelper
  def words_only(emotions_grid)
    emotions_grid.map(&:word)
  end

  def lookup_emotion(emotion_word)
    DatabaseFacade.emotions.find { |emotion| emotion.word == emotion_word }
  end
end