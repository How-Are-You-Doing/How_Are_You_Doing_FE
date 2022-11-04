class Emotion
  attr_reader :word, :definition, :id

  def initialize(emotion_data)
    @word = emotion_data[:attributes][:emotion]
    @definition = emotion_data[:attributes][:definition]
    @id = emotion_data[:id]
  end
end
