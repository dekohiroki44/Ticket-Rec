class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.string :name, default: ""
      t.string :artist
      t.date :date, null: false
      t.string :place
      t.text :content

      t.timestamps
    end
    add_index :events, [:user_id, :date]
  end
end
