namespace :import do
  task :curl_macbeth do
    `mkdir -p tmp/source`
    `curl http://dl.dropbox.com/u/28026453/scottish_play.zip > tmp/source/scottish_play.zip`
    `unzip tmp/source/scottish_play.zip -d tmp/source`
  end
  
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
