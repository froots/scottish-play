class Act < ActiveRecord::Base
  attr_accessible :number
  has_many :scenes
end
