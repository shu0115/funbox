class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist
  has_many   :tracks, dependent: :destroy

  scope :mine, ->(user) { where( playlists: { user_id: user.id } ) }

  validates :name, presence: true
end
