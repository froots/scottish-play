namespace :import do
  
  task :local => :environment do
    characters = Source::Characters.new("tmp/source/macbeth_characters.xml")
    characters.load
    characters.update

    play = Source::Play.new("tmp/source/macbeth.xml")
    play.load
    play.update

    puts "Updated:"
    puts "#{Character.count} characters"
    puts "#{Act.count} acts"
    puts "#{Scene.count} scenes"
    puts "#{Paragraph.count} paragraphs"
    puts "#{Line.count} lines"
  end
  
end