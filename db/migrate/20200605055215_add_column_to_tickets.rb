class AddColumnToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :prefecture, :string
  end
end
