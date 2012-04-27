class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :char_id
      t.string :name
      t.integer :speech_count
      t.string :short_name
      t.text :description

      t.timestamps
    end
  end
end
