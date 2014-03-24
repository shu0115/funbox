class UsersController < ApplicationController
  skip_before_filter :authenticate

  # ユーザ一覧
  def index(page)
    @users = User.order(created_at: :desc).page(page).per(100)
  end

  # ユーザのプレイリスト一覧
  def playlists(user_id)
    @user      = User.find_by(id: user_id)
    @playlists = Playlist.where(user_id: user_id).order(created_at: :desc)
  end

  # プレイリスト内トラック再生
  def playlist(user_id, id)
    session[:request_url] = user_playlist_url(user_id, id) if current_user.blank?

    @user       = User.find_by(id: user_id)
    @playlist   = Playlist.includes(:tracks).order("tracks.created_at ASC").find(id)
    @tracks     = @playlist.tracks
    @unique_ids = @tracks.pluck(:unique_id)
  end

  # ユーザのトラック全体から100曲ランダム再生
  def playall(user_id)
    @user        = User.find_by(id: user_id)
    @tracks      = Track.where(id: Track.mine(@user).pluck(:id).shuffle.first(100))
    @unique_ids  = Track.unique_ids(@tracks, shuffle: true)
    @tracks_hash = @tracks.index_by{ |x| x.unique_id }
  end
end
