class RenamePerformerColumnToTickets < ActiveRecord::Migration[5.2]
  def change
    rename_column :tickets, :performer, :artist
  end
end
