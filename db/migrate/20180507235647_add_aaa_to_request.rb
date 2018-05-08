class AddAaaToRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :requests, :archive_number, :string
    add_column :requests, :archived_at, :datetime
  end
end
