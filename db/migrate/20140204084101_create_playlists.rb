class CreatePlaylists < ActiveRecord::Migration[4.2]
  def change
    create_table :playlists do |t|
      t.references :user, index: true
      t.string :name
      t.references :playlist, index: true

      t.timestamps
    end
  end
end
