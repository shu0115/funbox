class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist, optional: true
  has_many   :tracks, dependent: :destroy

  scope :mine,   -> (user) { where( playlists: { user_id: user.id } ) }
  scope :active, -> { where('playlists.track_count > 0') }

  validates :name, presence: true

  # プレイリスト所有判定
  def mine?(user)
    return (self.user_id == user.try(:id) ? true : false)
  end
end
