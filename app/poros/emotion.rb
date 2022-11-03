class Emotion
  attr_reader :word, :definition, :id

  def initialize(emotion_data)
    @word = emotion_data["Word"]
    @definition = emotion_data["Definition"]
    @id = Faker::Number.unique.number
  end
end
