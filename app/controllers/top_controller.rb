class TopController < ApplicationController
  skip_before_filter :authenticate

  # トップ
  def index
    @tracks       = Track.where(hide_top_flag: false).random_tracks(100)
    @unique_ids   = Track.unique_ids(@tracks, shuffle: true).uniq
    @tracks_hash  = @tracks.index_by{ |x| x.unique_id }
  end

  # トップから非表示にする
  def hide(track_id)
    @track = Track.find_by(id: track_id)
    @track.update!(hide_top_flag: true)

    # redirect_to :root and return
    render layout: false
  end
end
