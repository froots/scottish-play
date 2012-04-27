class Line < ActiveRecord::Base
  attr_accessible :number, :text
  belongs_to :paragraph
end
