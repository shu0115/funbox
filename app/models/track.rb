class Track < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist

  # サムネイル画像URL
  def thumbnail_url
    "https://img.youtube.com/vi/#{self.unique_id}/0.jpg"
  end
end
