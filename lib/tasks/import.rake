namespace :import do
  
  task :local => :environment do
    characters = Source::Characters.new("tmp/source/macbeth_characters.xml")
    characters.load
    characters.update

    play = Source::Play.new("tmp/source/macbeth.xml")
    play.load
    play.update
  end
  
end