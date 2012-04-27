class Character < ActiveRecord::Base
  attr_accessible :char_id, :description, :name, :short_name, :speech_count
  has_many :paragraphs
end
