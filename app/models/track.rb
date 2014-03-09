class Track < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  # スコープ
  scope :mine, ->(user) { where( tracks: { user_id: user.id } ) }

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

    # ID羅列
    def id_list(tracks, shuffle=false)
      if shuffle.present?
        tracks.map { |t| t.unique_id }.shuffle.join(',')
      else
        tracks.map { |t| t.unique_id }.shuffle.join(',')
      end
    end

    # ランダム抽出
    def random_tracks(limit)
      ids = Track.pluck(:id)
      return Track.where(id: ids.shuffle.first(limit))
    end
  end
end
