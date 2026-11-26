class CreateBookmarks < ActiveRecord::Migration[8.1]
  def change
    create_table :bookmarks do |t|
      t.string :name
      t.text :description
      t.references :trip, null: false, foreign_key: true

      t.timestamps
    end
  end
end
