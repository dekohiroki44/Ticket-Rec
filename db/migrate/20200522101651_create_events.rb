class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.references :user, foreign_key: true
      t.string :name, default: ""
      t.string :performer
      t.date :date, null: false
      t.time :time
      t.string :place
      t.string :price
      t.text :content
      t.boolean :public, default: false, null: false
      t.boolean :done, null: false
      t.index :date

      t.timestamps
    end
  end
end
