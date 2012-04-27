class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.integer :number
      t.text :text

      t.timestamps
      t.references :paragraph
    end
  end
end
