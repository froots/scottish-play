class Scene < ActiveRecord::Base
  attr_accessible :number
  belongs_to :act
  has_many :paragraphs
  has_many :characters, :through => :paragraphs
end
