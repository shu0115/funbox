class UsersController < ApplicationController
  skip_before_action :authenticate

  # # ユーザ一覧
  # def index(page)
  #   @users = User.order(created_at: :desc).page(page).per(50)
  # end

  # ユーザのプレイリスト一覧
  def playlists(user_id)
    @user      = User.find_by(id: user_id)
    @playlists = Playlist.where(user_id: user_id).order(created_at: :desc)
  end

  # # プレイリスト内トラック再生
  # def playlist(user_id, id)
  #   session[:request_url] = user_playlist_url(user_id, id) if current_user.blank?

  #   @user       = User.find_by(id: user_id)
  #   @playlist   = Playlist.includes(:tracks).order("tracks.created_at ASC").find(id)
  #   @tracks     = @playlist.tracks
  #   @unique_ids = @tracks.pluck(:unique_id)
  # end

  # ユーザのトラック全体から100曲ランダム再生
  def playall(user_id)
    @user        = User.find_by(id: user_id)
    @tracks      = Track.where(id: Track.mine(@user).pluck(:id).shuffle.first(100))
    @unique_ids  = Track.unique_ids(@tracks, shuffle: true)
    @tracks_hash = @tracks.index_by{ |x| x.unique_id }
  end

  # # プレイリストに対するGood
  # def playlist_good_toggle(id)
  #   playlist = Playlist.find_by(id: id)
  #   good = Good.where(user_id: current_user.id, playlist_id: playlist.id).first_or_initialize
  #   if good.id.present?
  #     good.destroy
  #   else
  #     good.save!
  #   end

  #   render partial: '/users/playlist_good', locals: { playlist: playlist }
  # end
end
