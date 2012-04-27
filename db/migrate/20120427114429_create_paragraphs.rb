class CreateParagraphs < ActiveRecord::Migration
  def change
    create_table :paragraphs do |t|
      t.string :paragraph_type
      t.integer :section
      t.text :phonetic
      t.integer :word_count
      t.integer :char_count
      t.integer :chapter
      t.text :stem_text
      t.integer :paragraph_id
      t.integer :number

      t.references :scene
      t.references :character
      t.timestamps
    end
  end
end
