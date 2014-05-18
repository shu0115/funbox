class Track < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  # スコープ
  scope :mine, -> (user) { where(tracks: { user_id: user.id }) }

  # コールバック
  after_create  { |track| track.playlist.update(track_count: ActiveRecord::Base.connection.execute("SELECT COUNT(*) FROM tracks WHERE tracks.playlist_id = #{track.playlist_id}").first.first[1]) }
  after_destroy { |track| track.playlist.update(track_count: Track.where(playlist_id: track.playlist_id).count) }

  # サムネイル画像URL
  def thumbnail_url
    "https://img.youtube.com/vi/#{self.unique_id}/0.jpg"
  end

  private

  class << self
    # YouTube検索
    def youtube_search(word, unique_ids, page)
      if word.present?
        # YouTube検索
        client = YouTubeIt::Client.new
        videos = client.videos_by(query: word, order_by: 'viewCount', max_results: 50).videos
        # プレイリスト登録済み動画除外
        videos.delete_if{ |v| unique_ids.index(v.unique_id) }
        videos = Kaminari.paginate_array(videos).page(page).per(Settings.per_page)
      else
        videos = []
      end

      return videos
    end

    # 動画のユニークIDリスト
    def unique_ids(tracks, shuffle: false)
      ids = tracks.map { |t| t.unique_id }
      ids = ids.shuffle if shuffle.present?

      return ids
    end

    # ランダム抽出
    def random_tracks(limit)
      # ids = Track.pluck(:id)
      # return Track.where(id: ids.shuffle.first(limit))
      unique_ids = Track.pluck(:unique_id).uniq
      return Track.where(unique_id: unique_ids.shuffle.first(limit))
    end
  end
end
