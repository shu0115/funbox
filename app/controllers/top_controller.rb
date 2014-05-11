class TopController < ApplicationController
  skip_before_filter :authenticate

  # トップ
  def index
    @tracks       = Track.not_hide_top.random_tracks(100)
    @unique_ids   = Track.unique_ids(@tracks, shuffle: true)
    @tracks_hash  = @tracks.index_by{ |x| x.unique_id }
  end

  # トップから非表示にする
  def hide(track_id)
    track = Track.find_by(id: track_id)
    track.update!(hide_top_flag: true)

    redirect_to :root and return
  end
end
