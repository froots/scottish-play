class Paragraph < ActiveRecord::Base
  attr_accessible :chapter, :char_count, :number, :paragraph_id, :phonetic, :section, :stem_text, :paragraph_type, :word_count
  belongs_to :character
  belongs_to :scene
  has_many :lines

  def act
    scene.act
  end
end
