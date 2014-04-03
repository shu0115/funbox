class ViewCount < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  after_create { Playlist.find_by(id: self.playlist_id).update(view_count: ViewCount.where(playlist_id: self.playlist_id).count) }
end
