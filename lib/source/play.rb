require 'nokogiri'

module Source

  class Play
    def initialize(path)
      @path = path
    end

    def load(output = true)
      @doc = Nokogiri::XML load_file(output) do |config|
      end
      puts "Feed source has #{@doc.css('Act').size} acts, #{@doc.css('Scene').size} scenes, #{@doc.css('Paragraphs').size} paragraphs and #{@doc.css('Line').size} lines" if output
    end

    def load_file(output = true)
      file = open(@path)
      puts "Play source loaded successfully" if output
      file
    end

    def update(output = true)
      Act.destroy_all
      Scene.destroy_all
      Paragraph.destroy_all
      Line.destroy_all
      @doc.css('Act').each { |act| update_act(act) }
    end

  private

    def update_act(act)
      act_number = act['number'].to_i
      a = Act.find_or_initialize_by_number(act_number)
      a.save!
      process_scenes(a, act);
    end

    def process_scenes(act_model, act)
      act.css('Scene').each do |scene|
        scene_model = act_model.scenes.create({ number: scene['number'].to_i })
        process_paragraphs(scene_model, scene);
      end
    end

    def process_paragraphs(scene_model, scene)
      scene.css('Paragraphs').each do |paragraph|
        paragraph_model = scene_model.paragraphs.create({
          paragraph_type: paragraph.at_css('ParagraphType').text,
          section: paragraph.at_css('Section').text.to_i,
          phonetic: paragraph.at_css('PhoneticText').text,
          word_count: paragraph.at_css('WordCount').text.to_i,
          char_count: paragraph.at_css('CharCount').text.to_i,
          chapter: paragraph.at_css('Chapter').text.to_i,
          stem_text: paragraph.at_css('StemText').text,
          paragraph_id: paragraph.at_css('ParagraphID').text.to_i,
          number: paragraph.at_css('ParagraphNum').text.to_i,
        });
        paragraph_model.character = Character.find_by_char_id paragraph.at_css('CharID').text
        paragraph_model.save!
        process_lines(paragraph_model, paragraph)
      end
    end

    def process_lines(paragraph_model, paragraph)
      paragraph.css('Line').each do |line|
        paragraph_model.lines.create({
          number: line['number'].to_i,
          text: line.text
        })
      end
    end

  end

end