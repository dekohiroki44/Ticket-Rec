class AddRecommendToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :recommend, :string
    add_column :users, :recommend_image, :string
    add_column :users, :recommend_track, :string
  end
end
