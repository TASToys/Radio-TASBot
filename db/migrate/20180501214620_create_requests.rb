class CreateRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :requests do |t|
      t.string :songurl
      t.string :twitchname

      t.timestamps
    end
  end
end
