class ViewCount < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  after_create { Playlist.find_by(id: self.playlist_id).update(view_count: ViewCount.where(playlist_id: self.playlist_id).count) }

  class << self
    # 日別カウントに加算
    def add_daily_count(args={})
      return if args[:user].blank? or args[:playlist].blank?
      return if args[:user].id == args[:playlist].user_id  # 自分のプレイリストの場合は加算しない

      ViewCount.where(user_id: args[:user].id, playlist_id: args[:playlist].id, footprint_date: Date.today).first_or_create
    end
  end
end
