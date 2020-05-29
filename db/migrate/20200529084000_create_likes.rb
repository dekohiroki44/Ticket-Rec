class CreateLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :event_id

      t.timestamps

      t.index :user_id
      t.index :event_id
      t.index [:user_id, :event_id], unique: true
    end
  end
end
