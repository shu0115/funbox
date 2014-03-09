class TopController < ApplicationController
  skip_before_filter :authenticate

  # トップ
  def index
    @tracks       = Track.random_tracks(100)
    @unique_ids   = Track.unique_ids(@tracks, shuffle: true)
    @tracks_hash  = @tracks.index_by{ |x| x.unique_id }
  end
end
