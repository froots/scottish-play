require 'nokogiri'

module Source

  class Characters
    def initialize(path)
      @path = path
      @character_count = 0
    end

    def load(output = true)
      @doc = Nokogiri::XML load_file(output) do |config|
      end
      puts "Feed source has #{@doc.css('Characters')} characters" if output
    end

    def load_file(output = true)
      file = open(@path)
      puts "Character source loaded successfully" if output
      file
    end

    def update(output = true)
      @doc.css('Characters').each { |character| update_character(character) }
      puts "#{@character_count} characters added or modified" if output
    end

  private

    def update_character(character)
      char_id = character.at_css('CharID').text
      puts char_id
      c = Character.find_or_initialize_by_char_id(char_id)
      c.update_attributes(character_attributes(character))
      @character_count += 1
    end

    def character_attributes(character)
      {
        name: character.at_css('CharName').text,
        speech_count: character.at_css('SpeechCount').text.to_i,
        short_name: character.at_css('Abbrev').text,
        description: character.at_css('Description').text
      }
    end

  end

end