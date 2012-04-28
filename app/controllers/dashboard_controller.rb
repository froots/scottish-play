class DashboardController < ApplicationController
  def index
  	@paragraphs = Paragraph.where('number >=794').where('number <= 856').includes(:lines).order(:number)
  	@characters = @paragraphs.collect(&:character).uniq!
  end
end
