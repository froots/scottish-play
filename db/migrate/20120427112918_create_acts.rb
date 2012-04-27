class CreateActs < ActiveRecord::Migration
  def change
    create_table :acts do |t|
      t.integer :number

      t.timestamps
    end
  end
end
