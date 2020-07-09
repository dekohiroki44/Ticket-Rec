class CreateGeographies < ActiveRecord::Migration[5.2]
  def change
    create_table :geographies do |t|
      t.string :name, null: false
      t.float :latitude
      t.float :longitude

      t.timestamps
      t.index :name, unique: true
    end
  end
end
