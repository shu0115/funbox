class AddHideTopFlagToTracks < ActiveRecord::Migration
  def change
    add_column :tracks, :hide_top_flag, :boolean, default: false
  end
end
