class Line < ActiveRecord::Base
  attr_accessible :number, :text
  belongs_to :paragraph

  def scene
    paragraph.scene
  end

  def act
    paragraph.act
  end

  def character
    paragraph.character
  end
end
