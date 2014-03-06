class Playlist < ActiveRecord::Base
  belongs_to :user
  belongs_to :playlist
  has_many   :tracks, dependent: :destroy
end
