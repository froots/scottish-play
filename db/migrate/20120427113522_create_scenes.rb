class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.integer :number

      t.references :act
      t.timestamps
    end
  end
end
