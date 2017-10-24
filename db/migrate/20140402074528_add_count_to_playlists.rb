class AddCountToPlaylists < ActiveRecord::Migration[4.2]
  def change
    add_column :playlists, :track_count, :integer, default: 0
    add_column :playlists, :view_count, :integer, default: 0
  end
end
