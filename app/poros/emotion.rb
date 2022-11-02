class Emotion
  attr_reader :word, :definition

  def initialize(emotion_data)
    @word = emotion_data["Word"]
    @definition = emotion_data["Definition"]
  end
end
