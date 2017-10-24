class AddHideTopFlagToTracks < ActiveRecord::Migration[4.2]
  def change
    add_column :tracks, :hide_top_flag, :boolean, default: false
  end
end
