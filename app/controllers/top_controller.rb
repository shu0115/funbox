class TopController < ApplicationController
  skip_before_filter :authenticate

  # トップ
  def index
    @tracks = Track.random_tracks(100)
  end
end
