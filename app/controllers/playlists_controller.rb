class PlaylistsController < ApplicationController
  permits :user, :name, :playlist

  skip_before_action :authenticate, only: [:show, :recent, :popular, :tracks]
  before_action :redirect_public, only: [:show]
  before_action :set_playlist, only: [:show, :edit, :update, :destroy, :search, :search_pager]

  ## プライベート：自分のプレイリストのみ
  def index(search: {})
    @playlists = Playlist.where(user_id: current_user.id).order(created_at: :desc)

    if search.present?
      # @playlists = @playlists.where.like(name: "%#{search[:word]}%")
      @playlists.where!(Playlist.arel_table[:name].matches("%#{search[:word]}%"))
    end

    @playlist  = Playlist.new

    @search = search
  end

  # GET /playlists/1
  def show(id, word: '', page: 1, search: false)
    @tracks     = @playlist.tracks
    @unique_ids = @tracks.pluck(:unique_id)
    @word = word.presence || @playlist.name

    if search.present?
      @videos = Track.youtube_search(@word, @unique_ids, page)
    end
  end

  # GET /playlists/new
  def new
    @playlist = Playlist.new
  end

  # GET /playlists/1/edit
  def edit(id)
    # @playlist = Playlist.find(id)
  end

  # POST /playlists
  def create(playlist)
    @playlist = Playlist.new(playlist)
    @playlist.user = current_user
    @playlist.save!

    # redirect_to playlists_path and return
    redirect_to playlist_path(@playlist, search: true) and return
  end

  # PUT /playlists/1
  def update(id, playlist)
    # @playlist = Playlist.find(id)

    if @playlist.update(playlist)
      # redirect_to @playlist, notice: 'Playlist was successfully updated.'
      redirect_to playlists_path and return
    else
      render action: 'edit'
    end
  end

  # DELETE /playlists/1
  def destroy(id)
    current_user.playlists.find_by(id: id).destroy

    redirect_to playlists_url
  end

  # Youtube検索
  def search(id, word: '', page: 1)
    unique_ids = @playlist.tracks.mine(current_user).pluck(:unique_id)
    videos = Track.youtube_search(word, unique_ids, page)

    render partial: '/playlists/search_result', locals: { videos: videos, playlist: @playlist, word: word }
  end

  # # Youtube検索オートページャー
  # def search_pager(id, word: '', page: 1)
  #   unique_ids = @playlist.tracks.mine(current_user).pluck(:unique_id)
  #   videos = Track.youtube_search(word, unique_ids, page)

  #   render partial: '/playlists/search_pager', locals: { videos: videos, playlist: @playlist, word: word }
  # end

  # プレイリストプレイオール
  def all(checks: nil)
    checks.permit!
    tracks = Track.mine(current_user)
    tracks.where!(playlist_id: checks.values) if checks.present?
    @tracks = Track.where(id: tracks.pluck(:id).shuffle.first(100))
    @unique_ids   = Track.unique_ids(@tracks, shuffle: true)
    @tracks_hash  = @tracks.index_by{ |x| x.unique_id }
    @checks = checks
  end

  private

  # プレイリスト所有者以外、もしくは未ログインの場合はpublic用URLへ飛ばす
  def redirect_public
    playlist = Playlist.find_by(id: params[:id])

    if playlist.present? and (current_user.blank? or !playlist.mine?(current_user))
      redirect_to tracks_playlist_path(playlist) and return
    end
  end

  # プレイリスト取得
  def set_playlist
    @playlist = Playlist.mine(current_user).includes(:tracks).order("tracks.created_at ASC").find_by(id: params[:id])

    redirect_to playlists_path, alert: "プレイリストが存在しません。" and return if @playlist.blank?
  end
end
